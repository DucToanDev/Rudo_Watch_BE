<?php
require_once __DIR__ . '/../../../models/ReviewModel.php';
require_once __DIR__ . '/../../../core/Response.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';

class ReviewsController
{
    private $reviewModel;
    private $response;
    private $authMiddleware;

    public function __construct()
    {
        $this->reviewModel = new Reviews();
        $this->response = new Response();
        $this->authMiddleware = new AuthMiddleware();
    }

    // Lấy danh sách reviews
    // Endpoint: GET /api/v1/reviews
    public function index()
    {
        try {
            $params = [
                'product_id' => $_GET['product_id'] ?? '',
                'user_id' => $_GET['user_id'] ?? '',
                'rating' => $_GET['rating'] ?? '',
                'sort_by' => $_GET['sort_by'] ?? 'created_at',
                'sort_order' => $_GET['sort_order'] ?? 'DESC',
                'page' => $_GET['page'] ?? 1,
                'limit' => $_GET['limit'] ?? 10
            ];

            // Loại bỏ các tham số rỗng
            $params = array_filter($params, function ($value) {
                return $value !== '';
            });

            $result = $this->reviewModel->getAll($params);
            $this->response->json($result, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Lấy reviews theo product_id
    // Endpoint: GET /api/v1/reviews/product/{id}
    public function byProduct($productId)
    {
        try {
            if (!is_numeric($productId)) {
                $this->response->json(['error' => 'Product ID không hợp lệ'], 400);
                return;
            }

            $params = [
                'sort_by' => $_GET['sort_by'] ?? 'created_at',
                'sort_order' => $_GET['sort_order'] ?? 'DESC',
                'page' => $_GET['page'] ?? 1,
                'limit' => $_GET['limit'] ?? 10
            ];

            $result = $this->reviewModel->getByProductId($productId, $params);
            $this->response->json($result, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Lấy thống kê rating của sản phẩm
    // Endpoint: GET /api/v1/reviews/stats/{productId}
    public function stats($productId)
    {
        try {
            if (!is_numeric($productId)) {
                $this->response->json(['error' => 'Product ID không hợp lệ'], 400);
                return;
            }

            $result = $this->reviewModel->getProductRatingStats($productId);
            $this->response->json($result, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Lấy chi tiết review theo ID
    // Endpoint: GET /api/v1/reviews/{id}
    public function show($id)
    {
        try {
            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $review = $this->reviewModel->getById($id);

            if (!$review) {
                $this->response->json(['error' => 'Review không tồn tại'], 404);
                return;
            }

            $this->response->json($review, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Tạo review mới
    // Endpoint: POST /api/v1/reviews
    public function store($data)
    {
        try {
            // Xác thực user
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            // Lấy dữ liệu từ request
            if (!empty($_POST)) {
                $data = (object) $_POST;
            }

            // Validate dữ liệu
            $errors = $this->validateReviewData($data);
            if (!empty($errors)) {
                $this->response->json(['errors' => $errors], 400);
                return;
            }

            // Gán user_id từ token
            $data->user_id = $user['id'];

            // Kiểm tra user đã review sản phẩm này chưa
            if ($this->reviewModel->hasUserReviewed($data->user_id, $data->product_id)) {
                $this->response->json([
                    'error' => 'Bạn đã đánh giá sản phẩm này rồi'
                ], 400);
                return;
            }

            $review = $this->reviewModel->create($data);

            if ($review) {
                $this->response->json([
                    'message' => 'Tạo đánh giá thành công',
                    'data' => $review
                ], 201);
            } else {
                $this->response->json(['error' => 'Không thể tạo đánh giá'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Cập nhật review
    // Endpoint: PUT /api/v1/reviews/{id}
    public function update($id)
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

            // Kiểm tra review tồn tại
            $existingReview = $this->reviewModel->getById($id);
            if (!$existingReview) {
                $this->response->json(['error' => 'Review không tồn tại'], 404);
                return;
            }

            // Kiểm tra quyền (chỉ chủ sở hữu hoặc admin mới có thể sửa)
            if ($existingReview['user_id'] != $user['id'] && $user['role'] != 1) {
                $this->response->json(['error' => 'Bạn không có quyền sửa đánh giá này'], 403);
                return;
            }

            // Lấy dữ liệu từ request
            if (!empty($_POST)) {
                $data = (object) $_POST;
            } else {
                $data = json_decode(file_get_contents("php://input"));
            }

            // Validate rating nếu có
            if (isset($data->rating)) {
                if (!is_numeric($data->rating) || $data->rating < 1 || $data->rating > 5) {
                    $this->response->json(['error' => 'Rating phải từ 1 đến 5'], 400);
                    return;
                }
            }

            $review = $this->reviewModel->update($id, $data);

            if ($review) {
                $this->response->json([
                    'message' => 'Cập nhật đánh giá thành công',
                    'data' => $review
                ], 200);
            } else {
                $this->response->json(['error' => 'Không thể cập nhật đánh giá'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Xóa review
    // Endpoint: DELETE /api/v1/reviews/{id}
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

            // Kiểm tra review tồn tại
            $existingReview = $this->reviewModel->getById($id);
            if (!$existingReview) {
                $this->response->json(['error' => 'Review không tồn tại'], 404);
                return;
            }

            // Kiểm tra quyền (chỉ chủ sở hữu hoặc admin mới có thể xóa)
            if ($existingReview['user_id'] != $user['id'] && $user['role'] != 1) {
                $this->response->json(['error' => 'Bạn không có quyền xóa đánh giá này'], 403);
                return;
            }

            if ($this->reviewModel->delete($id)) {
                $this->response->json(['message' => 'Xóa đánh giá thành công'], 200);
            } else {
                $this->response->json(['error' => 'Không thể xóa đánh giá'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Lấy review của user hiện tại cho sản phẩm
    // Endpoint: GET /api/v1/reviews/my-review/{productId}
    public function myReview($productId)
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

            $review = $this->reviewModel->getUserReview($user['id'], $productId);

            if ($review) {
                $this->response->json($review, 200);
            } else {
                $this->response->json(['message' => 'Bạn chưa đánh giá sản phẩm này'], 404);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    // Validate dữ liệu review
    private function validateReviewData($data)
    {
        $errors = [];

        if (!isset($data->product_id) || empty($data->product_id)) {
            $errors[] = 'Product ID là bắt buộc';
        }

        if (!isset($data->content) || empty(trim($data->content))) {
            $errors[] = 'Nội dung đánh giá là bắt buộc';
        }

        if (!isset($data->rating)) {
            $errors[] = 'Rating là bắt buộc';
        } elseif (!is_numeric($data->rating) || $data->rating < 1 || $data->rating > 5) {
            $errors[] = 'Rating phải từ 1 đến 5';
        }

        return $errors;
    }
}
