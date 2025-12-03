<?php
require_once __DIR__ . '/../../../models/CartModel.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../../../core/Response.php';

class CartsController
{
    private $cartModel;
    private $authMiddleware;
    private $response;

    public function __construct()
    {
        $this->cartModel = new CartModel();
        $this->authMiddleware = new AuthMiddleware();
        $this->response = new Response();
    }

    /**
     * GET /api/v1/cart
     * Lấy giỏ hàng
     * - Nếu đã đăng nhập: lấy từ database
     * - Nếu chưa đăng nhập: trả về hướng dẫn lấy từ localStorage
     */
    public function index()
    {
        // Kiểm tra token có được gửi không
        $token = $this->authMiddleware->getTokenFromHeader();

        if ($token) {
            // Đã đăng nhập - lấy từ database
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return; // Response đã được gửi trong authenticate()
            }

            $result = $this->cartModel->getCartByUserId($user['id']);

            if ($result['success']) {
                $this->response->json([
                    'source' => 'database',
                    'cart' => $result['cart']
                ], 200);
            } else {
                $this->response->json([
                    'error' => $result['message']
                ], 500);
            }
        } else {
            // Chưa đăng nhập - hướng dẫn lấy từ localStorage
            $this->response->json([
                'source' => 'local',
                'message' => 'Vui lòng lấy giỏ hàng từ localStorage',
                'instruction' => 'Giỏ hàng được lưu tại localStorage với key "cart"'
            ], 200);
        }
    }

    /**
     * POST /api/v1/cart/add
     * Thêm sản phẩm vào giỏ hàng
     * Body: { variant_id: int, quantity: int }
     */
    public function add($data)
    {
        $token = $this->authMiddleware->getTokenFromHeader();

        if ($token) {
            // Đã đăng nhập - lưu vào database
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            $result = $this->cartModel->addItem($user['id'], $data);

            if ($result['success']) {
                $this->response->json([
                    'source' => 'database',
                    'message' => $result['message'],
                    'cart' => $result['cart']
                ], 200);
            } else {
                $this->response->json([
                    'error' => $result['message']
                ], 400);
            }
        } else {
            // Chưa đăng nhập - trả về hướng dẫn lưu localStorage
            $this->response->json([
                'source' => 'local',
                'message' => 'Vui lòng lưu sản phẩm vào localStorage',
                'action' => 'add',
                'data' => [
                    'variant_id' => $data->variant_id ?? null,
                    'quantity' => $data->quantity ?? 1
                ],
                'instruction' => 'Lưu vào localStorage với key "cart" dạng array, mỗi item có variant_id và quantity'
            ], 200);
        }
    }

    /**
     * PUT /api/v1/cart/update
     * Cập nhật số lượng sản phẩm
     * Body: { item_id: int (hoặc variant_id), quantity: int }
     */
    public function update($data)
    {
        $token = $this->authMiddleware->getTokenFromHeader();

        if ($token) {
            // Đã đăng nhập - cập nhật database
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            $result = $this->cartModel->updateItem($user['id'], $data);

            if ($result['success']) {
                $this->response->json([
                    'source' => 'database',
                    'message' => $result['message'],
                    'cart' => $result['cart']
                ], 200);
            } else {
                $this->response->json([
                    'error' => $result['message']
                ], 400);
            }
        } else {
            // Chưa đăng nhập - trả về hướng dẫn cập nhật localStorage
            $this->response->json([
                'source' => 'local',
                'message' => 'Vui lòng cập nhật sản phẩm trong localStorage',
                'action' => 'update',
                'data' => [
                    'variant_id' => $data->variant_id ?? null,
                    'quantity' => $data->quantity ?? 1
                ],
                'instruction' => 'Cập nhật quantity của item có variant_id tương ứng trong localStorage'
            ], 200);
        }
    }

    /**
     * DELETE /api/v1/cart/remove
     * Xóa sản phẩm khỏi giỏ hàng
     * Body hoặc Query: { item_id: int } hoặc { variant_id: int }
     */
    public function remove($data = null)
    {
        // Lấy data từ query string nếu DELETE không có body
        if (!$data) {
            $data = (object)[
                'item_id' => $_GET['item_id'] ?? null,
                'variant_id' => $_GET['variant_id'] ?? null
            ];
        }

        $token = $this->authMiddleware->getTokenFromHeader();

        if ($token) {
            // Đã đăng nhập - xóa từ database
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            $result = $this->cartModel->removeItem($user['id'], $data);

            if ($result['success']) {
                $this->response->json([
                    'source' => 'database',
                    'message' => $result['message'],
                    'cart' => $result['cart']
                ], 200);
            } else {
                $this->response->json([
                    'error' => $result['message']
                ], 400);
            }
        } else {
            // Chưa đăng nhập - trả về hướng dẫn xóa từ localStorage
            $this->response->json([
                'source' => 'local',
                'message' => 'Vui lòng xóa sản phẩm từ localStorage',
                'action' => 'remove',
                'data' => [
                    'variant_id' => $data->variant_id ?? null
                ],
                'instruction' => 'Xóa item có variant_id tương ứng khỏi localStorage'
            ], 200);
        }
    }

    /**
     * DELETE /api/v1/cart/clear
     * Xóa toàn bộ giỏ hàng
     */
    public function clear()
    {
        $token = $this->authMiddleware->getTokenFromHeader();

        if ($token) {
            // Đã đăng nhập - xóa từ database
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            $result = $this->cartModel->clearCart($user['id']);

            if ($result['success']) {
                $this->response->json([
                    'source' => 'database',
                    'message' => $result['message']
                ], 200);
            } else {
                $this->response->json([
                    'error' => $result['message']
                ], 500);
            }
        } else {
            // Chưa đăng nhập - trả về hướng dẫn xóa localStorage
            $this->response->json([
                'source' => 'local',
                'message' => 'Vui lòng xóa giỏ hàng từ localStorage',
                'action' => 'clear',
                'instruction' => 'Xóa key "cart" khỏi localStorage'
            ], 200);
        }
    }

    /**
     * POST /api/v1/cart/sync
     * Đồng bộ giỏ hàng từ localStorage khi đăng nhập
     */
    public function sync($data)
    {
        // Bắt buộc phải đăng nhập
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        $localItems = $data->items ?? [];

        $result = $this->cartModel->syncCart($user['id'], $localItems);

        if ($result['success']) {
            $this->response->json([
                'source' => 'database',
                'message' => $result['message'] ?? 'Đồng bộ thành công',
                'cart' => $result['cart'],
                'instruction' => 'Vui lòng xóa localStorage sau khi đồng bộ'
            ], 200);
        } else {
            $this->response->json([
                'error' => $result['message']
            ], 500);
        }
    }

    /**
     * GET /api/v1/cart/count
     * Lấy số lượng sản phẩm trong giỏ hàng
     */
    public function count()
    {
        $token = $this->authMiddleware->getTokenFromHeader();

        if ($token) {
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            $result = $this->cartModel->getCartCount($user['id']);

            $this->response->json([
                'source' => 'database',
                'count' => $result['count']
            ], 200);
        } else {
            $this->response->json([
                'source' => 'local',
                'message' => 'Vui lòng tính số lượng từ localStorage',
                'instruction' => 'Lấy cart từ localStorage và tính tổng quantity'
            ], 200);
        }
    }
}
