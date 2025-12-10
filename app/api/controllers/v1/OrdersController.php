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
     * Lấy danh sách đơn hàng của user đang đăng nhập
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
     * Lấy chi tiết đơn hàng
     */
    public function show($id)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        $userId = ($user['role'] === 'admin') ? null : $user['id'];

        $result = $this->orderModel->getOrderById($id, $userId);

        if ($result['success']) {
            $this->response->json($result['data'], 200);
        } else {
            $this->response->json(['error' => $result['message']], 404);
        }
    }

    /**
     * Tạo đơn hàng mới
     */
    public function store($data)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        // Chuyển đổi data thành object nếu là array
        if (is_array($data)) {
            $data = (object)$data;
            // Chuyển đổi items thành array các object nếu cần
            if (isset($data->items) && is_array($data->items)) {
                $items = [];
                foreach ($data->items as $item) {
                    $items[] = is_array($item) ? (object)$item : $item;
                }
                $data->items = $items;
            }
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
     * Admin cập nhật trạng thái đơn hàng
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
     * Admin cập nhật trạng thái thanh toán
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
     * Admin lấy tất cả đơn hàng
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
