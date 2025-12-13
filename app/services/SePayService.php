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

// bắt buộc phải sử dụng tài khoản ảo
    public function useVirtualAccount($orderId, $amount, $description = '')
    {
        try {
            // Lấy VA đã tạo sẵn trên SePay Dashboard
            $virtualAccount = $_ENV['SEPAY_VIRTUAL_ACCOUNT'] ?? '';
            $bankName = $_ENV['SEPAY_BANK'] ?? '';
            
            if (empty($virtualAccount)) {
                throw new Exception('Chưa cấu hình SEPAY_VIRTUAL_ACCOUNT');
            }
            
            if (empty($bankName)) {
                throw new Exception('Chưa cấu hình SEPAY_BANK');
            }

            // Tạo nội dung chuyển khoản để khớp đơn hàng
            $paymentContent = "DH{$orderId}";
            
            // Tạo QR Code với VA có sẵn
            $qrUrl = "https://qr.sepay.vn/img?" . http_build_query([
                'acc' => $virtualAccount,
                'bank' => $bankName,
                'amount' => $amount,
                'des' => $paymentContent,
                'template' => 'compact'
            ]);

            return [
                'success' => true,
                'virtual_account' => $virtualAccount,
                'account_number' => $virtualAccount,
                'bank_name' => $bankName,
                'qr_code_url' => $qrUrl,
                'payment_url' => $qrUrl,
                'order_id' => $orderId,
                'amount' => $amount,
                'payment_content' => $paymentContent
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => $e->getMessage()
            ];
        }
    }

    
     //Tạo mã QR Code thanh toán với Tài khoản ảo (VA)
    public function createPaymentQR($orderId, $amount, $description = '')
    {
        try {
            $virtualAccount = $_ENV['SEPAY_VIRTUAL_ACCOUNT'] ?? '';
            $bank = $_ENV['SEPAY_BANK'] ?? '';

            if (empty($virtualAccount)) {
                $account = $_ENV['SEPAY_ACCOUNT'] ?? '';
                if (empty($account) || empty($bank)) {
                    throw new Exception('Chưa cấu hình SEPAY_VIRTUAL_ACCOUNT');
                }
                $virtualAccount = $account;
            }

            if (empty($bank)) {
                throw new Exception('Chưa cấu hình SEPAY_BANK');
            }

            $amount = (float)$amount;
            if ($amount <= 0) {
                throw new Exception('Số tiền phải lớn hơn 0');
            }

            $paymentContent = !empty($description) ? $description : "DH{$orderId}";

            $qrUrl = "https://qr.sepay.vn/img?" . http_build_query([
                'acc' => $virtualAccount,
                'bank' => $bank,
                'amount' => $amount,
                'des' => $paymentContent,
                'template' => 'compact'
            ]);

            return [
                'success' => true,
                'qr_code_url' => $qrUrl,
                'payment_url' => $qrUrl,
                'order_id' => $orderId,
                'amount' => $amount,
                'virtual_account' => $virtualAccount,
                'account_number' => $virtualAccount,
                'account' => $virtualAccount,
                'bank' => $bank,
                'payment_content' => $paymentContent
            ];

        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => $e->getMessage()
            ];
        }
    }

    //Tạo thanh toán qua API SePay (nếu không có account/bank)
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
                'message' => $response['message'] ?? 'Không thể tạo thanh toán qua API SePay'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => $e->getMessage()
            ];
        }
    }

    //Kiểm tra trạng thái thanh toán từ SePay API
    public function checkPaymentStatus($transactionId)
    {
        try {
            if (empty($this->apiKey)) {
                throw new Exception('Chưa cấu hình SEPAY_API_KEY');
            }

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

    //Xác thực webhook từ SePay
    public function verifyWebhook($data, $signature)
    {
        try {
            // Nếu không có webhook secret hoặc signature, không thể xác thực
            if (empty($this->webhookSecret) || empty($signature)) {
                return false;
            }
            
            if (hash_equals($this->webhookSecret, $signature)) {
                return true;
            }

            $dataArray = is_object($data) ? json_decode(json_encode($data), true) : $data;
            
            if (isset($dataArray['signature'])) {
                unset($dataArray['signature']);
            }

            $rawJson = json_encode($dataArray, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
            
            // Thử với raw JSON
            $expectedSignature1 = hash_hmac('sha256', $rawJson, $this->webhookSecret);
            
            // Thử với sorted keys (một số service yêu cầu)
            ksort($dataArray);
            $sortedJson = json_encode($dataArray, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
            $expectedSignature2 = hash_hmac('sha256', $sortedJson, $this->webhookSecret);
            
            // So sánh với cả 2 cách (sử dụng hash_equals để tránh timing attack)
            $isValid1 = hash_equals($expectedSignature1, $signature);
            $isValid2 = hash_equals($expectedSignature2, $signature);
            
            return $isValid1 || $isValid2;
        } catch (Exception $e) {
            return false;
        }
    }

    //Xử lý webhook từ SePay
    public function handleWebhook($data)
    {
        try {
            $apiKey = $_SERVER['HTTP_X_API_KEY'] ?? '';
            $signature = $_SERVER['HTTP_X_SEPAY_SIGNATURE'] 
                      ?? $_SERVER['HTTP_X_WEBHOOK_SIGNATURE'] 
                      ?? $_SERVER['HTTP_SIGNATURE']
                      ?? (is_object($data) ? ($data->signature ?? '') : ($data['signature'] ?? ''))
                      ?? '';

            if (!empty($this->webhookSecret)) {
                $isValid = false;
                
                if (!empty($apiKey) && hash_equals($this->webhookSecret, $apiKey)) {
                    $isValid = true;
                }
                
                if (!$isValid && !empty($signature)) {
                    $dataForVerify = is_object($data) ? json_decode(json_encode($data), true) : $data;
                    if ($this->verifyWebhook($dataForVerify, $signature)) {
                        $isValid = true;
                    }
                }
                
                if (!$isValid && (!empty($apiKey) || !empty($signature))) {
                    return [
                        'success' => false,
                        'message' => 'Webhook authentication không hợp lệ'
                    ];
                }
            }

            // ========== BƯỚC 2: PARSE DỮ LIỆU WEBHOOK ==========
            if (is_object($data)) {
                $dataArray = json_decode(json_encode($data), true);
            } else {
                $dataArray = $data;
            }

            $gateway = $dataArray['gateway'] ?? null;
            $transactionDateRaw = $dataArray['transactionDate'] ?? $dataArray['transaction_date'] ?? null;
            
            // Chuyển đổi datetime từ ISO 8601 sang MySQL format
            $transactionDate = null;
            if ($transactionDateRaw) {
                try {
                    $dateTime = new DateTime($transactionDateRaw);
                    $transactionDate = $dateTime->format('Y-m-d H:i:s');
                } catch (Exception $e) {
                    $transactionDate = date('Y-m-d H:i:s');
                }
            } else {
                $transactionDate = date('Y-m-d H:i:s');
            }
            
            $accountNumber = $dataArray['accountNumber'] ?? $dataArray['account_number'] ?? null;
            $subAccount = $dataArray['subAccount'] ?? $dataArray['sub_account'] ?? null;
            $transferType = $dataArray['transferType'] ?? $dataArray['transfer_type'] ?? null;
            $transferAmount = (float)($dataArray['transferAmount'] ?? $dataArray['transfer_amount'] ?? 0);
            $accumulated = $dataArray['accumulated'] ?? null;
            $code = $dataArray['code'] ?? null;
            $transactionContent = $dataArray['content'] ?? $dataArray['transaction_content'] ?? null;
            $referenceNumber = $dataArray['referenceCode'] ?? $dataArray['reference_number'] ?? null;
            $body = $dataArray['description'] ?? $dataArray['body'] ?? null;

            // ========== BƯỚC 3: TÍNH TOÁN AMOUNT_IN VÀ AMOUNT_OUT ==========
            $amountIn = 0;
            $amountOut = 0;
            if ($transferType == "in") {
                $amountIn = $transferAmount;
            } else if ($transferType == "out") {
                $amountOut = $transferAmount;
            }

            // ========== BƯỚC 4: TÁCH MÃ ĐƠN HÀNG TỪ NỘI DUNG CHUYỂN KHOẢN ==========
            $orderId = null;
            if ($transactionContent) {
                // Thử format DH{order_id} trước (format chuẩn)
                $regex = '/DH(\d+)/i';
                preg_match($regex, $transactionContent, $matches);
                if (isset($matches[1]) && is_numeric($matches[1])) {
                    $orderId = (int)$matches[1];
                } else {
                    // Nếu không tìm thấy format DH, thử tìm số trong nội dung
                    // (một số trường hợp có thể chỉ có số order_id)
                    preg_match('/(\d+)/', $transactionContent, $matches);
                    if (isset($matches[1]) && is_numeric($matches[1])) {
                        $orderId = (int)$matches[1];
                    }
                }
            }

            // ========== BƯỚC 5: XÁC ĐỊNH TRẠNG THÁI THANH TOÁN ==========
            $status = 'pending';
            if ($transferType == "in" && $amountIn > 0) {
                $status = 'paid';
            } else if ($transferType == "out") {
                $status = 'failed';
            }

            return [
                'success' => true,
                'order_id' => $orderId,
                'status' => $status,
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
                ]
            ];

        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => $e->getMessage()
            ];
        }
    }

    //Gửi request đến SePay API
    private function makeRequest($method, $endpoint, $data = [])
    {
        $url = $this->apiUrl . $endpoint;

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30); // Timeout 30 giây
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10); // Connection timeout 10 giây

        if ($method === 'POST') {
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/json',
                'Accept: application/json',
                'User-Agent: RUDO-WATCH-API/1.0'
            ]);
        }

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        if ($curlError) {
            throw new Exception('SePay API connection error: ' . $curlError);
        }

        if ($httpCode !== 200) {
            $errorMessage = 'SePay API error: HTTP ' . $httpCode;
            if ($response) {
                $errorData = json_decode($response, true);
                if (isset($errorData['message'])) {
                    $errorMessage .= ' - ' . $errorData['message'];
                }
            }
            throw new Exception($errorMessage);
        }

        $decodedResponse = json_decode($response, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception('SePay API: Invalid JSON response - ' . json_last_error_msg());
        }

        return $decodedResponse;
    }
}