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

    /**
     * POST /api/v1/payments/create
     * Tạo thanh toán SePay cho đơn hàng
     */
    public function create($data)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        if (empty($data->order_id)) {
            $this->response->json(['error' => 'Vui lòng cung cấp order_id'], 400);
            return;
        }

        // Kiểm tra đơn hàng
        $order = $this->orderModel->getOrderById($data->order_id, $user['id']);
        if (!$order || !$order['success']) {
            $this->response->json(['error' => 'Đơn hàng không tồn tại'], 404);
            return;
        }

        $orderData = $order['data'];
        
        // Kiểm tra đơn hàng đã thanh toán chưa
        if ($orderData['payment_status'] === 'paid') {
            $this->response->json(['error' => 'Đơn hàng đã được thanh toán'], 400);
            return;
        }

        // Kiểm tra đơn hàng có phải của user không
        if ($orderData['user_id'] != $user['id']) {
            $this->response->json(['error' => 'Bạn không có quyền thanh toán đơn hàng này'], 403);
            return;
        }

        // Đảm bảo bảng payments tồn tại
        try {
            $this->paymentModel->ensureTableExists();
        } catch (Exception $e) {
            $this->response->json(['error' => 'Lỗi hệ thống: ' . $e->getMessage()], 500);
            return;
        }

        // Tạo thanh toán SePay với nội dung chuyển khoản: DH{order_id}
        $paymentContent = "DH{$data->order_id}";
        $qrResult = $this->sepayService->createPaymentQR(
            $data->order_id,
            $orderData['total'],
            $paymentContent
        );

        if (!$qrResult['success']) {
            $this->response->json(['error' => $qrResult['message']], 500);
            return;
        }

        // Lưu giao dịch thanh toán
        $paymentResult = $this->paymentModel->createPayment(
            $data->order_id,
            $orderData['total'],
            'sepay',
            $qrResult['transaction_id'] ?? null
        );

        if (!$paymentResult['success']) {
            $this->response->json(['error' => $paymentResult['message']], 500);
            return;
        }

        // Trả về thông tin thanh toán
        $this->response->json([
            'message' => 'Tạo thanh toán thành công',
            'data' => [
                'payment_id' => $paymentResult['payment_id'],
                'order_id' => $data->order_id,
                'amount' => $orderData['total'],
                'qr_code_url' => $qrResult['qr_code_url'] ?? '',
                'payment_url' => $qrResult['payment_url'] ?? '',
                'transaction_id' => $qrResult['transaction_id'] ?? null
            ]
        ], 200);
    }

    /**
     * POST /api/v1/payments/webhook
     * Webhook nhận thông báo từ SePay
     * Logic theo code mẫu: lưu vào tb_transactions, tách mã đơn hàng từ nội dung chuyển khoản
     */
    public function webhook()
    {
        // Lấy dữ liệu từ webhook (SePay gửi dạng JSON object, không phải array)
        $rawData = file_get_contents('php://input');
        $data = json_decode($rawData);

        // Nếu decode thành array, chuyển thành object
        if (is_array($data)) {
            $data = (object)$data;
        }

        if (!$data || !is_object($data)) {
            $this->response->json(['success' => false, 'message' => 'No data'], 400);
            return;
        }

        // Xử lý webhook từ SePay
        $webhookResult = $this->sepayService->handleWebhook($data);

        if (!$webhookResult['success']) {
            $this->response->json(['success' => false, 'message' => $webhookResult['message']], 400);
            return;
        }

        // Lưu giao dịch vào bảng tb_transactions
        $transactionData = $webhookResult['transaction_data'];
        $transactionResult = $this->transactionModel->createTransaction($transactionData);

        if (!$transactionResult['success']) {
            $this->response->json(['success' => false, 'message' => $transactionResult['message']], 500);
            return;
        }

        // Lấy mã đơn hàng từ kết quả xử lý webhook
        $orderId = $webhookResult['order_id'];
        $status = $webhookResult['status'];
        $amount = $webhookResult['amount'];

        // Nếu không tìm thấy mã đơn hàng từ nội dung thanh toán
        if (!is_numeric($orderId)) {
            $this->response->json([
                'success' => false, 
                'message' => 'Order not found. Order_id ' . $orderId
            ], 400);
            return;
        }

        // Tìm đơn hàng với mã đơn hàng và số tiền tương ứng
        // Điều kiện: id đơn hàng, số tiền, trạng thái đơn hàng phải là 'unpaid'
        $order = $this->orderModel->getOrderById($orderId);
        if (!$order || !$order['success']) {
            $this->response->json([
                'success' => false, 
                'message' => 'Order not found. Order_id ' . $orderId
            ], 404);
            return;
        }

        $orderData = $order['data'];

        // Kiểm tra số tiền và trạng thái thanh toán
        if ($orderData['payment_status'] !== 'unpaid') {
            // Đơn hàng đã thanh toán rồi, chỉ trả về success
            $this->response->json(['success' => true, 'message' => 'Order already paid']);
            return;
        }

        // Kiểm tra số tiền (cho phép sai số nhỏ do làm tròn)
        $orderTotal = (float)$orderData['total'];
        $paymentAmount = (float)$amount;
        if (abs($orderTotal - $paymentAmount) > 0.01) {
            $this->response->json([
                'success' => false, 
                'message' => 'Payment amount mismatch. Expected: ' . $orderTotal . ', Received: ' . $paymentAmount
            ], 400);
            return;
        }

        // Cập nhật trạng thái đơn hàng thành 'paid'
        $updateResult = $this->orderModel->updatePaymentStatus($orderId, 'paid');
        
        if (!$updateResult['success']) {
            $this->response->json([
                'success' => false, 
                'message' => 'Failed to update order status: ' . $updateResult['message']
            ], 500);
            return;
        }

        // Cập nhật payment record nếu có
        $payment = $this->paymentModel->getPaymentByOrderId($orderId);
        if ($payment && $status === 'paid') {
            $this->paymentModel->updatePaymentStatus($payment['id'], 'paid');
        }

        $this->response->json([
            'success' => true,
            'message' => 'Payment processed successfully',
            'order_id' => $orderId,
            'status' => 'paid'
        ], 200);
    }

    /**
     * GET /api/v1/payments/status/{order_id}
     * Kiểm tra trạng thái thanh toán
     */
    public function status($orderId)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        // Kiểm tra đơn hàng
        $order = $this->orderModel->getOrderById($orderId, $user['id']);
        if (!$order || !$order['success']) {
            $this->response->json(['error' => 'Đơn hàng không tồn tại'], 404);
            return;
        }

        // Lấy thông tin thanh toán
        $payment = $this->paymentModel->getPaymentByOrderId($orderId);

        if (!$payment) {
            $this->response->json([
                'status' => 'not_found',
                'message' => 'Chưa có giao dịch thanh toán'
            ], 200);
            return;
        }

        // Nếu có transaction_id, kiểm tra trạng thái từ SePay
        if ($payment['gateway_transaction_id']) {
            $statusResult = $this->sepayService->checkPaymentStatus($payment['gateway_transaction_id']);
            if ($statusResult['success'] && $statusResult['status'] !== $payment['status']) {
                // Cập nhật trạng thái nếu khác
                $this->paymentModel->updatePaymentStatus($payment['id'], $statusResult['status']);
                $payment['status'] = $statusResult['status'];
            }
        }

        $this->response->json([
            'payment_status' => $payment['status'],
            'order_status' => $order['data']['status'],
            'payment_method' => $payment['gateway_name'], 
            'amount' => $payment['amount'],
            'created_at' => $payment['created_at'],
            'transaction_id' => $payment['gateway_transaction_id'] ?? null
        ], 200);
    }
}

