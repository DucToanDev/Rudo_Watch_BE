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

            // Tạo QR Code URL
            $qrUrl = "https://qr.sepay.vn/img?acc=" . urlencode($account) . 
                     "&bank=" . urlencode($bank) . 
                     "&amount=" . $amount . 
                     "&des=" . urlencode($description ?: "Thanh toan don hang #{$orderId}");

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
     */
    public function handleWebhook($data)
    {
        try {
            // Xác thực webhook
            $signature = $_SERVER['HTTP_X_SEPAY_SIGNATURE'] ?? '';
            if (!$this->verifyWebhook($data, $signature)) {
                return [
                    'success' => false,
                    'message' => 'Webhook signature không hợp lệ'
                ];
            }

            // Xử lý dữ liệu webhook
            $transactionId = $data['transaction_id'] ?? null;
            $orderId = $data['order_id'] ?? null;
            $status = $data['status'] ?? 'pending';
            $amount = $data['amount'] ?? 0;

            return [
                'success' => true,
                'transaction_id' => $transactionId,
                'order_id' => $orderId,
                'status' => $status, // paid, pending, failed
                'amount' => $amount,
                'data' => $data
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

