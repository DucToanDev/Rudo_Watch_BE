<?php

class SePayService
{
    private $apiKey;
    private $apiUrl = 'https://api.sepay.vn';
    private $webhookSecret;

    public function __construct()
    {
        $this->apiKey = $_ENV['SEPAY_API_KEY'] ?? '';
        $this->webhookSecret = $_ENV['SEPAY_WEBHOOK_SECRET'] ?? '';
    }

    /**
     * Tạo mã QR Code thanh toán
     * @param string $orderId Mã đơn hàng
     * @param float $amount Số tiền
     * @param string $description Mô tả
     * @return array
     */
    public function createPaymentQR($orderId, $amount, $description = '')
    {
        try {
            if (empty($this->apiKey)) {
                throw new Exception('Chưa cấu hình SEPAY_API_KEY');
            }

            // Tạo URL QR Code SePay
            $account = $_ENV['SEPAY_ACCOUNT'] ?? '';
            $bank = $_ENV['SEPAY_BANK'] ?? '';

            if (empty($account) || empty($bank)) {
                // Nếu không có account/bank, sử dụng API để tạo QR
                return $this->createPaymentViaAPI($orderId, $amount, $description);
            }

            // Tạo QR Code URL với format nội dung chuyển khoản: DH{order_id}
            $paymentContent = "DH{$orderId}";
            $qrUrl = "https://qr.sepay.vn/img?acc=" . urlencode($account) . 
                     "&bank=" . urlencode($bank) . 
                     "&amount=" . $amount . 
                     "&des=" . urlencode($paymentContent);

            return [
                'success' => true,
                'qr_code_url' => $qrUrl,
                'payment_url' => $qrUrl,
                'order_id' => $orderId,
                'amount' => $amount
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => $e->getMessage()
            ];
        }
    }

    /**
     * Tạo thanh toán qua API SePay
     */
    private function createPaymentViaAPI($orderId, $amount, $description)
    {
        try {
            $data = [
                'api_key' => $this->apiKey,
                'order_id' => $orderId,
                'amount' => $amount,
                'description' => $description ?: "Thanh toan don hang #{$orderId}",
                'return_url' => $_ENV['SEPAY_RETURN_URL'] ?? '',
                'cancel_url' => $_ENV['SEPAY_CANCEL_URL'] ?? ''
            ];

            $response = $this->makeRequest('POST', '/payment/create', $data);

            if ($response && isset($response['success']) && $response['success']) {
                return [
                    'success' => true,
                    'payment_url' => $response['payment_url'] ?? '',
                    'qr_code_url' => $response['qr_code_url'] ?? '',
                    'order_id' => $orderId,
                    'amount' => $amount,
                    'transaction_id' => $response['transaction_id'] ?? null
                ];
            }

            return [
                'success' => false,
                'message' => $response['message'] ?? 'Không thể tạo thanh toán'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => $e->getMessage()
            ];
        }
    }

    /**
     * Kiểm tra trạng thái thanh toán
     */
    public function checkPaymentStatus($transactionId)
    {
        try {
            $data = [
                'api_key' => $this->apiKey,
                'transaction_id' => $transactionId
            ];

            $response = $this->makeRequest('POST', '/payment/check', $data);

            if ($response && isset($response['status'])) {
                return [
                    'success' => true,
                    'status' => $response['status'], // paid, pending, failed
                    'transaction_id' => $transactionId,
                    'amount' => $response['amount'] ?? 0,
                    'order_id' => $response['order_id'] ?? null
                ];
            }

            return [
                'success' => false,
                'message' => 'Không thể kiểm tra trạng thái thanh toán'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => $e->getMessage()
            ];
        }
    }

    /**
     * Xác thực webhook từ SePay
     * SePay có thể gửi signature trong header hoặc trong body
     */
    public function verifyWebhook($data, $signature)
    {
        try {
            if (empty($this->webhookSecret) || empty($signature)) {
                return false;
            }

            // Chuyển data thành array nếu là object để encode đúng
            $dataArray = is_object($data) ? json_decode(json_encode($data), true) : $data;
            
            // Tạo signature từ raw JSON string (theo format SePay)
            // SePay có thể sử dụng raw body hoặc sorted JSON
            $rawJson = json_encode($dataArray, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
            
            // Thử với raw JSON
            $expectedSignature1 = hash_hmac('sha256', $rawJson, $this->webhookSecret);
            
            // Thử với sorted keys (một số service yêu cầu)
            ksort($dataArray);
            $sortedJson = json_encode($dataArray, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
            $expectedSignature2 = hash_hmac('sha256', $sortedJson, $this->webhookSecret);
            
            // So sánh với cả 2 cách
            $isValid1 = hash_equals($expectedSignature1, $signature);
            $isValid2 = hash_equals($expectedSignature2, $signature);
            
            return $isValid1 || $isValid2;
        } catch (Exception $e) {
            error_log("SePayService::verifyWebhook - Error: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Xử lý webhook từ SePay
     * Logic theo code mẫu: tách mã đơn hàng từ nội dung chuyển khoản (format: DH{order_id})
     */
    public function handleWebhook($data)
    {
        try {
            // Xác thực webhook (tùy chọn, có thể bỏ qua nếu SePay không gửi signature)
            $signature = $_SERVER['HTTP_X_SEPAY_SIGNATURE'] ?? $_SERVER['HTTP_X_WEBHOOK_SIGNATURE'] ?? '';
            
            // Log để debug
            error_log("SePayService::handleWebhook - Webhook secret configured: " . (!empty($this->webhookSecret) ? 'Yes' : 'No'));
            error_log("SePayService::handleWebhook - Signature received: " . (!empty($signature) ? substr($signature, 0, 20) . '...' : 'None'));
            
            // Chỉ xác thực signature nếu có webhook secret VÀ có signature
            if (!empty($this->webhookSecret)) {
                if (empty($signature)) {
                    // Có webhook secret nhưng không có signature - có thể SePay không gửi
                    // Log warning nhưng vẫn xử lý (cho phép test local)
                    error_log("SePayService::handleWebhook - WARNING: Webhook secret configured but no signature received. Processing anyway for testing.");
                } else {
                    // Có cả secret và signature - kiểm tra
                    // Chuyển data thành array để verify
                    $dataForVerify = is_object($data) ? json_decode(json_encode($data), true) : $data;
                    if (!$this->verifyWebhook($dataForVerify, $signature)) {
                        error_log("SePayService::handleWebhook - Signature verification failed");
                        error_log("SePayService::handleWebhook - Expected signature: " . substr(hash_hmac('sha256', json_encode($dataForVerify), $this->webhookSecret), 0, 20) . '...');
                        error_log("SePayService::handleWebhook - Received signature: " . substr($signature, 0, 20) . '...');
                        
                        return [
                            'success' => false,
                            'message' => 'Webhook signature không hợp lệ'
                        ];
                    }
                    error_log("SePayService::handleWebhook - Signature verified successfully");
                }
            } else {
                // Không có webhook secret - bỏ qua xác thực (cho phép test)
                error_log("SePayService::handleWebhook - No webhook secret configured, skipping signature verification");
            }

            // Chuyển đổi data thành array để xử lý dễ dàng hơn
            if (is_object($data)) {
                $dataArray = json_decode(json_encode($data), true);
            } else {
                $dataArray = $data;
            }
            
            // Xử lý dữ liệu webhook theo format SePay
            // Xem: https://docs.sepay.vn/tich-hop-webhooks.html#du-lieu
            $gateway = $dataArray['gateway'] ?? null;
            $transactionDateRaw = $dataArray['transactionDate'] ?? null;
            
            // Chuyển đổi datetime từ ISO 8601 (2025-12-10T10:00:00Z) sang MySQL format (2025-12-10 10:00:00)
            $transactionDate = null;
            if ($transactionDateRaw) {
                try {
                    // Tạo DateTime object từ ISO 8601 format
                    $dateTime = new DateTime($transactionDateRaw);
                    // Chuyển sang MySQL datetime format
                    $transactionDate = $dateTime->format('Y-m-d H:i:s');
                } catch (Exception $e) {
                    error_log("SePayService::handleWebhook - Invalid date format: " . $transactionDateRaw);
                    // Nếu không parse được, thử format trực tiếp hoặc dùng NOW()
                    $transactionDate = date('Y-m-d H:i:s');
                }
            }
            
            $accountNumber = $dataArray['accountNumber'] ?? null;
            $subAccount = $dataArray['subAccount'] ?? null;
            $transferType = $dataArray['transferType'] ?? null;
            $transferAmount = $dataArray['transferAmount'] ?? 0;
            $accumulated = $dataArray['accumulated'] ?? null;
            $code = $dataArray['code'] ?? null;
            $transactionContent = $dataArray['content'] ?? null;
            $referenceNumber = $dataArray['referenceCode'] ?? null;
            $body = $dataArray['description'] ?? null;

            // Tính amount_in và amount_out
            $amountIn = 0;
            $amountOut = 0;
            if ($transferType == "in") {
                $amountIn = $transferAmount;
            } else if ($transferType == "out") {
                $amountOut = $transferAmount;
            }

            // Tách mã đơn hàng từ nội dung chuyển khoản
            // Format: DH{order_id} (ví dụ: DH123)
            $orderId = null;
            if ($transactionContent) {
                $regex = '/DH(\d+)/';
                preg_match($regex, $transactionContent, $matches);
                if (isset($matches[1]) && is_numeric($matches[1])) {
                    $orderId = (int)$matches[1];
                }
            }

            // Xác định trạng thái thanh toán
            $status = 'pending';
            if ($transferType == "in" && $amountIn > 0) {
                $status = 'paid';
            } else if ($transferType == "out") {
                $status = 'failed';
            }

            return [
                'success' => true,
                'order_id' => $orderId,
                'status' => $status, // paid, pending, failed
                'amount' => $amountIn,
                'transaction_data' => [
                    'gateway' => $gateway,
                    'transaction_date' => $transactionDate,
                    'account_number' => $accountNumber,
                    'sub_account' => $subAccount,
                    'amount_in' => $amountIn,
                    'amount_out' => $amountOut,
                    'accumulated' => $accumulated,
                    'code' => $code,
                    'transaction_content' => $transactionContent,
                    'reference_number' => $referenceNumber,
                    'body' => $body
                ],
                'raw_data' => $data
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => $e->getMessage()
            ];
        }
    }

    /**
     * Gửi request đến SePay API
     */
    private function makeRequest($method, $endpoint, $data = [])
    {
        $url = $this->apiUrl . $endpoint;

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        if ($method === 'POST') {
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/json',
                'Accept: application/json'
            ]);
        }

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode !== 200) {
            throw new Exception('SePay API error: HTTP ' . $httpCode);
        }

        return json_decode($response, true);
    }
}

