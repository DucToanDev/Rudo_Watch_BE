<?php

require_once __DIR__ . '/../../../models/PaymentModel.php';
require_once __DIR__ . '/../../../models/OrderModel.php';
require_once __DIR__ . '/../../../models/TransactionModel.php';
require_once __DIR__ . '/../../../services/SePayService.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../../../core/Response.php';

class PaymentController
{
    private $paymentModel;
    private $orderModel;
    private $transactionModel;
    private $sepayService;
    private $authMiddleware;
    private $response;

    public function __construct()
    {
        $this->paymentModel = new PaymentModel();
        $this->orderModel = new OrderModel();
        $this->transactionModel = new TransactionModel();
        $this->sepayService = new SePayService();
        $this->authMiddleware = new AuthMiddleware();
        $this->response = new Response();
    }

    //Tạo mã QR Code thanh toán SePay cho đơn hàng
    public function create($data)
    {
        try {
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            if (empty($data)) {
                $rawInput = file_get_contents("php://input");
                if (!empty($rawInput)) {
                    $decoded = json_decode($rawInput, true);
                    if ($decoded && json_last_error() === JSON_ERROR_NONE) {
                        $data = (object)$decoded;
                    } elseif (!empty($_POST)) {
                        $data = (object) $_POST;
                    }
                } elseif (!empty($_POST)) {
                    $data = (object) $_POST;
                }
            }

            // Chuyển đổi data thành object nếu là array
            if (is_array($data)) {
                $data = (object)$data;
            }

            // Validation
            if (empty($data) || empty($data->order_id)) {
                $this->response->json([
                    'status' => 'error',
                    'statusCode' => 400,
                    'data' => [
                        'error' => 'Vui lòng cung cấp order_id'
                    ]
                ], 400);
                return;
            }

            $orderId = (int)$data->order_id;

            // Kiểm tra đơn hàng tồn tại và thuộc về user
            $order = $this->orderModel->getOrderById($orderId, $user['id']);
            if (!$order || !$order['success']) {
                $this->response->json([
                    'status' => 'error',
                    'statusCode' => 404,
                    'data' => [
                        'error' => 'Đơn hàng không tồn tại'
                    ]
                ], 404);
                return;
            }

            $orderData = $order['data'];
            
            // Kiểm tra đơn hàng đã thanh toán chưa
            $paymentStatus = strtolower($orderData['payment_status'] ?? 'unpaid');
            if ($paymentStatus === 'paid') {
                $this->response->json([
                    'status' => 'error',
                    'statusCode' => 400,
                    'data' => [
                        'error' => 'Đơn hàng đã được thanh toán'
                    ]
                ], 400);
                return;
            }

            // Kiểm tra quyền truy cập
            if ($orderData['user_id'] != $user['id']) {
                $this->response->json([
                    'status' => 'error',
                    'statusCode' => 403,
                    'data' => [
                        'error' => 'Bạn không có quyền thanh toán đơn hàng này'
                    ]
                ], 403);
                return;
            }

            // Lấy số tiền chính xác của đơn hàng
            $amount = (float)$orderData['total'];
            if ($amount <= 0) {
                $this->response->json([
                    'status' => 'error',
                    'statusCode' => 400,
                    'data' => [
                        'error' => 'Số tiền đơn hàng không hợp lệ'
                    ]
                ], 400);
                return;
            }

            // Tạo thanh toán SePay 
            $paymentContent = "DH{$orderId}";
            
            // Tạo QR Code với Tài khoản ảo (VA)
            $qrResult = $this->sepayService->createPaymentQR(
                $orderId,
                $amount,
                $paymentContent
            );

            if (!$qrResult['success']) {
                $this->response->json([
                    'status' => 'error',
                    'statusCode' => 500,
                    'data' => [
                        'error' => $qrResult['message'] ?? 'Không thể tạo mã QR thanh toán'
                    ]
                ], 500);
                return;
            }

            $paymentResult = $this->paymentModel->createPayment(
                $orderId,
                $amount,
                'sepay',
                $qrResult['transaction_id'] ?? null
            );

            $this->response->json([
                'status' => 'success',
                'statusCode' => 200,
                'data' => [
                    'order_id' => $orderId,
                    'amount' => $amount,
                    'account_number' => $qrResult['account_number'] ?? $qrResult['virtual_account'] ?? '',
                    'bank_name' => $qrResult['bank'] ?? '',
                    'payment_content' => $qrResult['payment_content'] ?? $paymentContent,
                    'qr_code_url' => $qrResult['qr_code_url'] ?? ''
                ]
            ], 200);

        } catch (Exception $e) {
            $this->response->json([
                'status' => 'error',
                'statusCode' => 500,
                'data' => [
                    'error' => 'Lỗi hệ thống'
                ]
            ], 500);
        }
    }

    //Webhook endpoint nhận thông báo từ SePay
    public function webhook()
    {
        $webhookLogFile = __DIR__ . '/../../../../logs/webhook_' . date('Y-m-d') . '.log';
        $logDir = dirname($webhookLogFile);
        if (!is_dir($logDir)) {
            @mkdir($logDir, 0755, true);
        }
        
        $logToFile = function($message) use ($webhookLogFile) {
            $timestamp = date('Y-m-d H:i:s');
            @file_put_contents($webhookLogFile, "[{$timestamp}] {$message}\n", FILE_APPEND);
        };
        
        try {
            $requestId = uniqid('webhook_', true);
            $logToFile("=== WEBHOOK REQUEST [{$requestId}] ===");

            $rawData = file_get_contents('php://input');
            if (empty($rawData)) {
                $this->response->json([
                    'success' => false,
                    'message' => 'Empty request body'
                ], 200);
                return;
            }

            $data = json_decode($rawData);
            if (json_last_error() !== JSON_ERROR_NONE || !$data) {
                $this->response->json([
                    'success' => false,
                    'message' => 'Invalid JSON format'
                ], 400);
                return;
            }

            if (is_array($data)) {
                $data = (object)$data;
            }

            // Xác thực webhook
            $webhookResult = $this->sepayService->handleWebhook($data);
            
            if (!$webhookResult['success']) {
                $logToFile("Webhook [{$requestId}]: Processing failed - " . $webhookResult['message']);
                $this->response->json([
                    'success' => false,
                    'message' => $webhookResult['message']
                ], 200);
                return;
            }

            // ========== BƯỚC 4: LƯU GIAO DỊCH VÀO DATABASE ==========
            $transactionData = $webhookResult['transaction_data'];
            
            // Đảm bảo transaction_data là array
            if (is_object($transactionData)) {
                $transactionData = (array)$transactionData;
            }

            $this->transactionModel->createTransaction($transactionData);

            $orderId = $webhookResult['order_id'];
            $status = $webhookResult['status'];
            $amount = $webhookResult['amount'];

            if (!is_numeric($orderId) || $orderId <= 0) {
                $this->response->json([
                    'success' => false,
                    'message' => 'Không tìm thấy mã đơn hàng trong nội dung chuyển khoản'
                ], 400);
                return;
            }

            $order = $this->orderModel->getOrderById($orderId);
            if (!$order || !$order['success']) {
                $this->response->json([
                    'success' => false,
                    'message' => "Đơn hàng không tồn tại"
                ], 404);
                return;
            }

            $orderData = $order['data'];
            $paymentStatus = strtolower($orderData['payment_status'] ?? 'unpaid');
            
            if ($paymentStatus === 'paid') {
                $this->response->json([
                    'success' => true,
                    'message' => 'Đơn hàng đã được thanh toán'
                ], 200);
                return;
            }

            $orderTotal = (float)$orderData['total'];
            $paymentAmount = (float)$amount;
            $tolerance = 0.01;

            if (abs($orderTotal - $paymentAmount) > $tolerance) {
                $this->response->json([
                    'success' => false,
                    'message' => "Số tiền không khớp"
                ], 400);
                return;
            }

            if ($status === 'paid' && $amount > 0) {
                $updateResult = $this->orderModel->updatePaymentStatus($orderId, 'paid');
                
                if (!$updateResult['success']) {
                    $this->response->json([
                        'success' => false,
                        'message' => 'Không thể cập nhật trạng thái đơn hàng'
                    ], 500);
                    return;
                }

                $payment = $this->paymentModel->getPaymentByOrderId($orderId);
                if ($payment) {
                    $this->paymentModel->updatePaymentStatus($payment['id'], 'paid');
                }

                $logToFile("Webhook [{$requestId}]: Order #{$orderId} updated to 'paid'");
            }
            
            $this->response->json([
                'success' => true,
                'message' => 'Xử lý webhook thành công'
            ], 200);

        } catch (Exception $e) {
            $requestId = $requestId ?? uniqid('webhook_', true);
            $logToFile("Webhook [{$requestId}]: EXCEPTION - " . $e->getMessage());
            
            $this->response->json([
                'success' => false,
                'message' => 'Lỗi xử lý webhook'
            ], 200);
        }
    }

    //Kiểm tra trạng thái thanh toán đơn hàng
    public function status($orderId)
    {
        try {
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            if (!is_numeric($orderId)) {
                $this->response->json([
                    'status' => 'error',
                    'statusCode' => 400,
                    'data' => [
                        'error' => 'Order ID không hợp lệ'
                    ]
                ], 400);
                return;
            }

            $order = $this->orderModel->getOrderById($orderId, $user['id']);
            if (!$order || !$order['success']) {
                $this->response->json([
                    'status' => 'error',
                    'statusCode' => 404,
                    'data' => [
                        'error' => 'Đơn hàng không tồn tại'
                    ]
                ], 404);
                return;
            }

            $orderData = $order['data'];
            
            $payment = $this->paymentModel->getPaymentByOrderId($orderId);
            $transaction = $this->transactionModel->getTransactionByOrderId($orderId);

            $paymentStatus = strtolower($orderData['payment_status'] ?? 'unpaid');
            
            if ($transaction && $transaction['amount_in'] > 0 && $paymentStatus !== 'paid') {
                $updateResult = $this->orderModel->updatePaymentStatus($orderId, 'paid');
                if ($updateResult['success']) {
                    $paymentStatus = 'paid';
                }
            }

            $this->response->json([
                'status' => 'success',
                'statusCode' => 200,
                'data' => [
                    'order_id' => $orderId,
                    'payment_status' => $paymentStatus,
                    'order_status' => $orderData['status'],
                    'payment_method' => $payment['gateway_name'] ?? 'sepay',
                    'amount' => (float)$orderData['total'],
                    'is_paid' => $paymentStatus === 'paid',
                    'has_transaction' => $transaction !== null,
                    'transaction_id' => $payment['gateway_transaction_id'] ?? ($transaction['code'] ?? null),
                    'created_at' => $orderData['created_at'],
                    'updated_at' => $orderData['updated_at']
                ]
            ], 200);

        } catch (Exception $e) {
            $this->response->json([
                'status' => 'error',
                'statusCode' => 500,
                'data' => [
                    'error' => 'Lỗi hệ thống'
                ]
            ], 500);
        }
    }
}