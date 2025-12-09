<?php
require_once __DIR__ . '/../../../models/OrderModel.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../../../core/Response.php';

class OrdersController
{
    private $orderModel;
    private $authMiddleware;
    private $response;

    public function __construct()
    {
        $this->orderModel = new OrderModel();
        $this->authMiddleware = new AuthMiddleware();
        $this->response = new Response();
    }

    /**
     * GET /api/v1/orders
     * Lấy danh sách đơn hàng của user đang đăng nhập
     * Query params: page, limit, status
     */
    public function index()
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        $params = [
            'page' => $_GET['page'] ?? 1,
            'limit' => $_GET['limit'] ?? 10,
            'status' => $_GET['status'] ?? null
        ];

        $result = $this->orderModel->getOrdersByUserId($user['id'], $params);

        if ($result['success']) {
            $this->response->json($result['data'], 200);
        } else {
            $this->response->json(['error' => $result['message']], 500);
        }
    }

    /**
     * GET /api/v1/orders/{id}
     * Lấy chi tiết đơn hàng
     */
    public function show($id)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        // Nếu là admin, có thể xem tất cả đơn hàng
        $userId = ($user['role'] === 'admin') ? null : $user['id'];

        $result = $this->orderModel->getOrderById($id, $userId);

        if ($result['success']) {
            $this->response->json($result['data'], 200);
        } else {
            $this->response->json(['error' => $result['message']], 404);
        }
    }

    /**
     * POST /api/v1/orders
     * Tạo đơn hàng mới
     * Body: { 
     *   items: [{ variant_id: int, quantity: int }], 
     *   address: { name, phone, province, district, ward, detail },
     *   payment_method: 'cod' | 'sepay' | 'banking' | 'momo',
     *   note: string,
     *   voucher_id: int,
     *   shipping_method_id: int
     * }
     */
    public function store($data)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        $result = $this->orderModel->createOrder($user['id'], $data);

        if ($result['success']) {
            $this->response->json([
                'message' => 'Đặt hàng thành công',
                'data' => $result['data']
            ], 201);
        } else {
            $this->response->json(['error' => $result['message']], 400);
        }
    }

    /**
     * PUT /api/v1/orders/{id}/cancel
     * User hủy đơn hàng
     */
    public function cancel($id)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        $result = $this->orderModel->cancelOrder($id, $user['id']);

        if ($result['success']) {
            $this->response->json(['message' => $result['message']], 200);
        } else {
            $this->response->json(['error' => $result['message']], 400);
        }
    }

    /**
     * PUT /api/v1/orders/{id}/status
     * Admin cập nhật trạng thái đơn hàng
     * Body: { status: 'pending' | 'confirmed' | 'processing' | 'shipping' | 'delivered' | 'cancelled' }
     */
    public function updateStatus($id)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        $data = json_decode(file_get_contents("php://input"));
        $status = $data->status ?? null;

        if (!$status) {
            $this->response->json(['error' => 'Vui lòng cung cấp trạng thái'], 400);
            return;
        }

        $result = $this->orderModel->updateStatus($id, $status);

        if ($result['success']) {
            $this->response->json(['message' => $result['message']], 200);
        } else {
            $this->response->json(['error' => $result['message']], 400);
        }
    }

    /**
     * PUT /api/v1/orders/{id}/payment-status
     * Admin cập nhật trạng thái thanh toán
     * Body: { payment_status: 'unpaid' | 'paid' | 'refunded' }
     */
    public function updatePaymentStatus($id)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        $data = json_decode(file_get_contents("php://input"));
        $paymentStatus = $data->payment_status ?? null;

        if (!$paymentStatus) {
            $this->response->json(['error' => 'Vui lòng cung cấp trạng thái thanh toán'], 400);
            return;
        }

        $result = $this->orderModel->updatePaymentStatus($id, $paymentStatus);

        if ($result['success']) {
            $this->response->json(['message' => $result['message']], 200);
        } else {
            $this->response->json(['error' => $result['message']], 400);
        }
    }

    /**
     * GET /api/v1/orders/admin
     * Admin lấy tất cả đơn hàng
     * Query params: page, limit, status, search
     */
    public function admin()
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        $params = [
            'page' => $_GET['page'] ?? 1,
            'limit' => $_GET['limit'] ?? 10,
            'status' => $_GET['status'] ?? null,
            'search' => $_GET['search'] ?? null
        ];

        $result = $this->orderModel->getAllOrders($params);

        if ($result['success']) {
            $this->response->json($result['data'], 200);
        } else {
            $this->response->json(['error' => $result['message']], 500);
        }
    }

    /**
     * GET /api/v1/orders/statistics
     * Admin xem thống kê đơn hàng
     */
    public function statistics()
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        $result = $this->orderModel->getStatistics();

        if ($result['success']) {
            $this->response->json($result['data'], 200);
        } else {
            $this->response->json(['error' => $result['message']], 500);
        }
    }
}
