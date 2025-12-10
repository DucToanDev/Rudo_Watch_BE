<?php
require_once __DIR__ . '/../../../models/ShippingMethodModel.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../../../core/Response.php';

class ShippingMethodsController
{
    private $shippingModel;
    private $authMiddleware;
    private $response;

    public function __construct()
    {
        $this->shippingModel = new ShippingMethodModel();
        $this->authMiddleware = new AuthMiddleware();
        $this->response = new Response();
    }

    /**
     * GET /api/v1/shipping-methods
     * Lấy danh sách phương thức vận chuyển đang hoạt động
     */
    public function index()
    {
        $result = $this->shippingModel->getAll();

        if ($result['success']) {
            $this->response->json($result['data'], 200);
        } else {
            $this->response->json(['error' => $result['message']], 500);
        }
    }

    /**
     * GET /api/v1/shipping-methods/{id}
     * Lấy chi tiết phương thức vận chuyển
     */
    public function show($id)
    {
        $result = $this->shippingModel->getById($id);

        if ($result['success']) {
            $this->response->json($result['data'], 200);
        } else {
            $this->response->json(['error' => $result['message']], 404);
        }
    }

    /**
     * POST /api/v1/shipping-methods
     * Tạo phương thức vận chuyển mới (Admin only)
     */
    public function store($data)
    {
        // Kiểm tra quyền admin
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        // Chuyển đổi data thành object nếu là array
        if (is_array($data)) {
            $data = (object)$data;
        }

        $result = $this->shippingModel->create($data);

        if ($result['success']) {
            $this->response->json([
                'message' => $result['message'],
                'data' => $result['data']
            ], 201);
        } else {
            $this->response->json(['error' => $result['message']], 400);
        }
    }

    /**
     * PUT /api/v1/shipping-methods/{id}
     * Cập nhật phương thức vận chuyển (Admin only)
     */
    public function update($id)
    {
        // Kiểm tra quyền admin
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        $data = json_decode(file_get_contents("php://input"));
        $result = $this->shippingModel->update($id, $data);

        if ($result['success']) {
            $this->response->json([
                'message' => $result['message'],
                'data' => $result['data']
            ], 200);
        } else {
            $this->response->json(['error' => $result['message']], 400);
        }
    }

    /**
     * DELETE /api/v1/shipping-methods/{id}
     * Xóa phương thức vận chuyển (Admin only)
     */
    public function destroy($id)
    {
        // Kiểm tra quyền admin
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        $result = $this->shippingModel->delete($id);

        if ($result['success']) {
            $this->response->json(['message' => $result['message']], 200);
        } else {
            $this->response->json(['error' => $result['message']], 400);
        }
    }

    /**
     * POST /api/v1/shipping-methods/calculate
     * Tính phí vận chuyển dựa trên phương thức và tổng đơn hàng
     */
    public function calculate($data)
    {
        // Chuyển đổi data thành object nếu là array
        if (is_array($data)) {
            $data = (object)$data;
        }

        $methodId = $data->method_id ?? null;
        $orderTotal = $data->order_total ?? 0;

        if (!$methodId) {
            $this->response->json(['error' => 'Vui lòng chọn phương thức vận chuyển'], 400);
            return;
        }

        $result = $this->shippingModel->calculateShipping($methodId, $orderTotal);

        if ($result['success']) {
            $this->response->json($result['data'], 200);
        } else {
            $this->response->json(['error' => $result['message']], 400);
        }
    }

    /**
     * GET /api/v1/shipping-methods/admin
     * Lấy tất cả phương thức vận chuyển (Admin only)
     */
    public function admin()
    {
        // Kiểm tra quyền admin
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        $result = $this->shippingModel->getAllAdmin();

        if ($result['success']) {
            $this->response->json($result['data'], 200);
        } else {
            $this->response->json(['error' => $result['message']], 500);
        }
    }
}
