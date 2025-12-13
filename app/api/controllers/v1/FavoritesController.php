<?php
require_once __DIR__ . '/../../../models/FavoriteModel.php';
require_once __DIR__ . '/../../../models/ProductModel.php';
require_once __DIR__ . '/../../../core/Response.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';

class FavoritesController
{
    private $favoriteModel;
    private $productModel;
    private $response;
    private $authMiddleware;

    public function __construct()
    {
        $this->favoriteModel = new Favorites();
        $this->productModel = new Products();
        $this->response = new Response();
        $this->authMiddleware = new AuthMiddleware();
    }

    // Lấy danh sách favorites của user hiện tại
    // Endpoint: GET /api/v1/favorites
    public function index()
    {
        try {
            // Xác thực user
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            $params = [
                'sort_by' => $_GET['sort_by'] ?? 'id',
                'sort_order' => $_GET['sort_order'] ?? 'DESC',
                'page' => $_GET['page'] ?? 1,
                'limit' => $_GET['limit'] ?? 10
            ];

            $result = $this->favoriteModel->getAllByUserId($user['id'], $params);
            $this->response->json($result, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Lấy chi tiết favorite theo ID
    // Endpoint: GET /api/v1/favorites/{id}
    public function show($id)
    {
        try {
            // Xác thực user
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $favorite = $this->favoriteModel->getById($id);

            if (!$favorite) {
                $this->response->json(['error' => 'Favorite không tồn tại'], 404);
                return;
            }

            // Kiểm tra quyền (chỉ chủ sở hữu mới có thể xem)
            if ($favorite['user_id'] != $user['id'] && $user['role'] != 1) {
                $this->response->json(['error' => 'Bạn không có quyền xem favorite này'], 403);
                return;
            }

            $this->response->json($favorite, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Thêm sản phẩm vào favorites
    // Endpoint: POST /api/v1/favorites
    public function store($data)
    {
        try {
            // Xác thực user
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            // Nếu data null hoặc không hợp lệ, thử parse lại từ raw input
            if (empty($data) || (is_array($data) && !isset($data['product_id']))) {
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

            // Validate dữ liệu
            if (empty($data) || !isset($data->product_id) || empty($data->product_id)) {
                $this->response->json(['error' => 'Product ID là bắt buộc'], 400);
                return;
            }

            if (!is_numeric($data->product_id)) {
                $this->response->json(['error' => 'Product ID không hợp lệ'], 400);
                return;
            }

            // Kiểm tra product có tồn tại không
            $product = $this->productModel->getById($data->product_id);
            if (!$product) {
                $this->response->json([
                    'error' => 'Sản phẩm không tồn tại',
                    'product_id' => $data->product_id
                ], 404);
                return;
            }

            // Kiểm tra sản phẩm có đang active không
            if (isset($product['status']) && $product['status'] != 1) {
                $this->response->json([
                    'error' => 'Sản phẩm không khả dụng'
                ], 400);
                return;
            }

            // Thêm vào favorites
            $result = $this->favoriteModel->create($user['id'], $data->product_id);

            if ($result['success']) {
                $this->response->json([
                    'message' => 'Đã thêm vào danh sách yêu thích',
                    'data' => $result['data']
                ], 201);
            } else {
                $this->response->json([
                    'error' => $result['message']
                ], 400);
            }
        } catch (PDOException $e) {
            // Xử lý lỗi database cụ thể
            $errorCode = $e->getCode();
            $errorMessage = $e->getMessage();
            
            // Lỗi duplicate entry
            if ($errorCode == 23000 || strpos($errorMessage, 'Duplicate entry') !== false) {
                $this->response->json([
                    'error' => 'Sản phẩm đã có trong danh sách yêu thích'
                ], 400);
            } else {
                $this->response->json([
                    'error' => 'Lỗi database: ' . $errorMessage
                ], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Xóa favorite theo ID
    // Endpoint: DELETE /api/v1/favorites/{id}
    public function destroy($id)
    {
        try {
            // Xác thực user
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            // Kiểm tra favorite tồn tại
            $existingFavorite = $this->favoriteModel->getById($id);
            if (!$existingFavorite) {
                $this->response->json(['error' => 'Favorite không tồn tại'], 404);
                return;
            }

            // Kiểm tra quyền (chỉ chủ sở hữu hoặc admin mới có thể xóa)
            if ($existingFavorite['user_id'] != $user['id'] && $user['role'] != 1) {
                $this->response->json(['error' => 'Bạn không có quyền xóa favorite này'], 403);
                return;
            }

            if ($this->favoriteModel->delete($id)) {
                $this->response->json(['message' => 'Đã xóa khỏi danh sách yêu thích'], 200);
            } else {
                $this->response->json(['error' => 'Không thể xóa favorite'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Xóa favorite theo product_id
    // Endpoint: DELETE /api/v1/favorites/product/{product_id}
    public function deleteByProduct($productId)
    {
        try {
            // Xác thực user
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            if (!is_numeric($productId)) {
                $this->response->json(['error' => 'Product ID không hợp lệ'], 400);
                return;
            }

            // Kiểm tra favorite tồn tại
            $existingFavorite = $this->favoriteModel->getByUserAndProduct($user['id'], $productId);
            if (!$existingFavorite) {
                $this->response->json(['error' => 'Sản phẩm không có trong danh sách yêu thích'], 404);
                return;
            }

            if ($this->favoriteModel->deleteByUserAndProduct($user['id'], $productId)) {
                $this->response->json(['message' => 'Đã xóa khỏi danh sách yêu thích'], 200);
            } else {
                $this->response->json(['error' => 'Không thể xóa favorite'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Kiểm tra sản phẩm đã được favorite chưa
    // Endpoint: GET /api/v1/favorites/check/{product_id}
    public function check($productId)
    {
        try {
            // Xác thực user
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            if (!is_numeric($productId)) {
                $this->response->json(['error' => 'Product ID không hợp lệ'], 400);
                return;
            }

            $favorite = $this->favoriteModel->isFavorite($user['id'], $productId);

            $this->response->json([
                'is_favorite' => $favorite ? true : false,
                'favorite_id' => $favorite ? $favorite['id'] : null
            ], 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Đếm số lượng favorites của user
    // Endpoint: GET /api/v1/favorites/count
    public function count()
    {
        try {
            // Xác thực user
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            $total = $this->favoriteModel->countByUserId($user['id']);

            $this->response->json([
                'total' => $total
            ], 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }
}

