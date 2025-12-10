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
     */
    public function verifyWebhook($data, $signature)
    {
        try {
            if (empty($this->webhookSecret)) {
                return false;
            }

            // Tạo signature từ data
            $expectedSignature = hash_hmac('sha256', json_encode($data), $this->webhookSecret);

            return hash_equals($expectedSignature, $signature);
        } catch (Exception $e) {
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
            $signature = $_SERVER['HTTP_X_SEPAY_SIGNATURE'] ?? '';
            if (!empty($this->webhookSecret) && !$this->verifyWebhook($data, $signature)) {
                return [
                    'success' => false,
                    'message' => 'Webhook signature không hợp lệ'
                ];
            }

            // Xử lý dữ liệu webhook theo format SePay
            // Xem: https://docs.sepay.vn/tich-hop-webhooks.html#du-lieu
            $gateway = $data->gateway ?? $data['gateway'] ?? null;
            $transactionDate = $data->transactionDate ?? $data['transactionDate'] ?? null;
            $accountNumber = $data->accountNumber ?? $data['accountNumber'] ?? null;
            $subAccount = $data->subAccount ?? $data['subAccount'] ?? null;
            $transferType = $data->transferType ?? $data['transferType'] ?? null;
            $transferAmount = $data->transferAmount ?? $data['transferAmount'] ?? 0;
            $accumulated = $data->accumulated ?? $data['accumulated'] ?? null;
            $code = $data->code ?? $data['code'] ?? null;
            $transactionContent = $data->content ?? $data['content'] ?? null;
            $referenceNumber = $data->referenceCode ?? $data['referenceCode'] ?? null;
            $body = $data->description ?? $data['description'] ?? null;

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

