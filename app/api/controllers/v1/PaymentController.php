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

        // Chuyển đổi data thành object nếu là array
        if (is_array($data)) {
            $data = (object)$data;
        }

        if (empty($data) || empty($data->order_id)) {
            $this->response->json(['error' => 'Vui lòng cung cấp order_id'], 400);
            return;
        }

        // Kiểm tra đơn hàng
        $order = $this->orderModel->getOrderById($data->order_id, $user['id']);
        if (!$order || !$order['success']) {
            $errorMessage = $order['message'] ?? 'Đơn hàng không tồn tại';
            // Nếu không tìm thấy, có thể do đơn hàng không thuộc về user này
            // Hoặc đơn hàng không tồn tại
            $this->response->json([
                'error' => $errorMessage,
                'debug' => [
                    'order_id' => $data->order_id,
                    'user_id' => $user['id']
                ]
            ], 404);
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
     * 
     * LƯU Ý: Endpoint này KHÔNG cần authentication vì được SePay gọi tự động
     */
    public function webhook()
    {
        // Log để debug - quan trọng để biết webhook có được gọi không
        error_log("=== WEBHOOK RECEIVED ===");
        error_log("Request method: " . $_SERVER['REQUEST_METHOD']);
        error_log("Content-Type: " . ($_SERVER['CONTENT_TYPE'] ?? 'not set'));
        error_log("Remote IP: " . ($_SERVER['REMOTE_ADDR'] ?? 'unknown'));
        error_log("User Agent: " . ($_SERVER['HTTP_USER_AGENT'] ?? 'unknown'));
        error_log("REQUEST_URI: " . ($_SERVER['REQUEST_URI'] ?? 'unknown'));
        
        // Log tất cả headers liên quan đến signature
        $allHeaders = getallheaders();
        error_log("All headers: " . json_encode($allHeaders));
        foreach ($_SERVER as $key => $value) {
            if (stripos($key, 'HTTP_') === 0 || stripos($key, 'SIGNATURE') !== false) {
                error_log("Header $key: " . (is_string($value) ? substr($value, 0, 100) : json_encode($value)));
            }
        }
        
        // Lấy dữ liệu từ webhook (SePay gửi dạng JSON object, không phải array)
        $rawData = file_get_contents('php://input');
        error_log("Raw webhook data length: " . strlen($rawData));
        error_log("Raw webhook data: " . substr($rawData, 0, 500));
        
        $data = json_decode($rawData);

        // Nếu decode thành array, chuyển thành object
        if (is_array($data)) {
            $data = (object)$data;
        }

        if (!$data || !is_object($data)) {
            error_log("Webhook: Invalid data format");
            $this->response->json(['success' => false, 'message' => 'No data'], 400);
            return;
        }

        error_log("Webhook data decoded: " . json_encode($data));

        // Xử lý webhook từ SePay
        $webhookResult = $this->sepayService->handleWebhook($data);
        error_log("Webhook result: " . json_encode($webhookResult));

        if (!$webhookResult['success']) {
            $this->response->json(['success' => false, 'message' => $webhookResult['message']], 400);
            return;
        }

        // Lưu giao dịch vào bảng tb_transactions
        $transactionData = $webhookResult['transaction_data'];
        
        // Đảm bảo transaction_data là array (TransactionModel expect array)
        if (is_object($transactionData)) {
            $transactionData = (array)$transactionData;
        }
        
        error_log("Transaction data to save: " . json_encode($transactionData));
        
        $transactionResult = $this->transactionModel->createTransaction($transactionData);
        error_log("Transaction save result: " . json_encode($transactionResult));

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

        // Tìm đơn hàng với mã đơn hàng
        // Code mẫu SePay kiểm tra: id, total, payment_status='Unpaid' trong WHERE clause
        // Code hiện tại lấy order trước, kiểm tra sau (linh hoạt hơn)
        $order = $this->orderModel->getOrderById($orderId);
        if (!$order || !$order['success']) {
            $this->response->json([
                'success' => false, 
                'message' => 'Order not found. Order_id ' . $orderId
            ], 404);
            return;
        }

        $orderData = $order['data'];

        // Kiểm tra trạng thái thanh toán (hỗ trợ cả chữ hoa và chữ thường)
        // Code mẫu SePay dùng 'Unpaid'/'Paid', code hiện tại dùng 'unpaid'/'paid'
        $paymentStatusLower = strtolower($orderData['payment_status'] ?? '');
        if ($paymentStatusLower !== 'unpaid') {
            // Đơn hàng đã thanh toán rồi, chỉ trả về success
            $this->response->json(['success' => true, 'message' => 'Order already paid']);
            return;
        }

        // Kiểm tra số tiền (cho phép sai số nhỏ do làm tròn)
        // Code mẫu SePay kiểm tra trong WHERE clause, code hiện tại kiểm tra sau khi lấy order
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
     * Frontend sẽ polling endpoint này để biết khi nào thanh toán thành công
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

        $orderData = $order['data'];
        
        // Lấy thông tin thanh toán (nếu có)
        $payment = $this->paymentModel->getPaymentByOrderId($orderId);

        // Trả về trạng thái từ order (webhook cập nhật trực tiếp vào orders.payment_status)
        $paymentStatus = $orderData['payment_status'] ?? 'unpaid';
        
        // Nếu có payment record, ưu tiên dùng status từ đó
        if ($payment) {
            $paymentStatus = $payment['status'] ?? $paymentStatus;
            
            // Nếu có transaction_id, kiểm tra trạng thái từ SePay (optional)
            if ($payment['gateway_transaction_id']) {
                $statusResult = $this->sepayService->checkPaymentStatus($payment['gateway_transaction_id']);
                if ($statusResult['success'] && $statusResult['status'] !== $payment['status']) {
                    // Cập nhật trạng thái nếu khác
                    $this->paymentModel->updatePaymentStatus($payment['id'], $statusResult['status']);
                    $paymentStatus = $statusResult['status'];
                }
            }
        }

        // Kiểm tra xem có transaction trong tb_transactions không (webhook đã lưu)
        $transaction = $this->transactionModel->getTransactionByOrderId($orderId);
        
        // Nếu có transaction thành công (amount_in > 0) nhưng payment_status chưa được cập nhật
        // Tự động cập nhật payment_status từ transaction
        if ($transaction && $transaction['amount_in'] > 0 && $paymentStatus !== 'paid') {
            // Có transaction thành công nhưng order chưa được cập nhật
            // Cập nhật payment_status thành 'paid'
            $updateResult = $this->orderModel->updatePaymentStatus($orderId, 'paid');
            if ($updateResult['success']) {
                $paymentStatus = 'paid';
                error_log("PaymentController::status - Auto-updated payment_status to 'paid' from transaction");
            }
        }
        
        $this->response->json([
            'payment_status' => $paymentStatus, // 'unpaid', 'paid', 'failed'
            'order_status' => $orderData['status'],
            'payment_method' => $payment['gateway_name'] ?? 'sepay',
            'amount' => $orderData['total'],
            'order_total' => $orderData['total'],
            'created_at' => $orderData['created_at'],
            'transaction_id' => $payment['gateway_transaction_id'] ?? ($transaction['code'] ?? null),
            'is_paid' => $paymentStatus === 'paid', // Boolean để frontend dễ check
            'has_transaction' => $transaction !== null // Có giao dịch trong tb_transactions
        ], 200);
    }
}

