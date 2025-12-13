<?php
require_once __DIR__ . '/../../../models/CommentModel.php';
require_once __DIR__ . '/../../../models/PostModel.php';
require_once __DIR__ . '/../../../core/Response.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';

class CommentsController
{
    private $commentModel;
    private $postModel;
    private $response;
    private $authMiddleware;

    public function __construct()
    {
        $this->commentModel = new Comments();
        $this->postModel = new Posts();
        $this->response = new Response();
        $this->authMiddleware = new AuthMiddleware();
    }

    /**
     * GET /api/v1/comments - Lấy danh sách comments
     */
    public function index()
    {
        try {
            $params = [
                'post_id' => $_GET['post_id'] ?? '',
                'user_id' => $_GET['user_id'] ?? '',
                'sort_by' => $_GET['sort_by'] ?? 'created_at',
                'sort_order' => $_GET['sort_order'] ?? 'DESC',
                'page' => $_GET['page'] ?? 1,
                'limit' => $_GET['limit'] ?? 10
            ];

            // Loại bỏ các tham số rỗng
            $params = array_filter($params, function ($value) {
                return $value !== '';
            });

            $result = $this->commentModel->getAll($params);
            $this->response->json($result, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * GET /api/v1/comments/post/{id} - Lấy comments theo post_id
     */
    public function byPost($postId)
    {
        try {
            if (!is_numeric($postId)) {
                $this->response->json(['error' => 'Post ID không hợp lệ'], 400);
                return;
            }

            $params = [
                'sort_by' => $_GET['sort_by'] ?? 'created_at',
                'sort_order' => $_GET['sort_order'] ?? 'DESC',
                'page' => $_GET['page'] ?? 1,
                'limit' => $_GET['limit'] ?? 10
            ];

            $result = $this->commentModel->getByPostId($postId, $params);
            $this->response->json($result, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * GET /api/v1/comments/{id} - Lấy chi tiết comment
     */
    public function show($id)
    {
        try {
            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $comment = $this->commentModel->getById($id);
            if (!$comment) {
                $this->response->json(['error' => 'Comment không tồn tại'], 404);
                return;
            }

            $this->response->json($comment, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * POST /api/v1/comments - Tạo comment mới
     */
    public function store($data)
    {
        try {
            // Xác thực user
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }

            // Xử lý dữ liệu từ form-data hoặc JSON
            if (empty($data)) {
                $data = json_decode(file_get_contents("php://input"));
            } else {
                if (is_array($data)) {
                    $data = (object)$data;
                }
            }

            if (!$data) {
                $this->response->json(['error' => 'Dữ liệu không hợp lệ'], 400);
                return;
            }

            // Validate
            $errors = [];
            if (empty($data->post_id)) {
                $errors['post_id'] = 'Post ID là bắt buộc';
            } elseif (!is_numeric($data->post_id)) {
                $errors['post_id'] = 'Post ID phải là số';
            }

            if (empty($data->content)) {
                $errors['content'] = 'Nội dung comment là bắt buộc';
            } elseif (strlen(trim($data->content)) < 1) {
                $errors['content'] = 'Nội dung comment không được để trống';
            }

            if (!empty($errors)) {
                $this->response->json(['errors' => $errors], 400);
                return;
            }

            // Kiểm tra post tồn tại
            $post = $this->postModel->getById($data->post_id);
            if (!$post) {
                $this->response->json(['error' => 'Bài viết không tồn tại'], 404);
                return;
            }

            // Tạo comment
            $commentData = (object)[
                'user_id' => $user['id'],
                'post_id' => $data->post_id,
                'content' => trim($data->content)
            ];

            $result = $this->commentModel->create($commentData);

            if ($result) {
                $this->response->json([
                    'message' => 'Tạo comment thành công',
                    'data' => $result
                ], 201);
            } else {
                $this->response->json(['error' => 'Không thể tạo comment'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * PUT /api/v1/comments/{id} - Cập nhật comment
     */
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

            $comment = $this->commentModel->getById($id);
            if (!$comment) {
                $this->response->json(['error' => 'Comment không tồn tại'], 404);
                return;
            }

            // Chỉ cho phép user sở hữu comment hoặc admin mới được sửa
            if ($comment['user_id'] != $user['id'] && $user['role'] != 1) {
                $this->response->json(['error' => 'Bạn không có quyền sửa comment này'], 403);
                return;
            }

            // Xử lý dữ liệu
            $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
            if (strpos($contentType, 'multipart/form-data') !== false) {
                $data = (object)$_POST;
            } else {
                $data = json_decode(file_get_contents("php://input"));
            }

            if (!$data) {
                $this->response->json(['error' => 'Dữ liệu không hợp lệ'], 400);
                return;
            }

            // Validate
            if (isset($data->content) && empty(trim($data->content))) {
                $this->response->json(['error' => 'Nội dung comment không được để trống'], 400);
                return;
            }

            $result = $this->commentModel->update($id, $data);

            if ($result) {
                $this->response->json([
                    'message' => 'Cập nhật comment thành công',
                    'data' => $result
                ], 200);
            } else {
                $this->response->json(['error' => 'Không thể cập nhật comment'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * DELETE /api/v1/comments/{id} - Xóa comment
     */
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

            $comment = $this->commentModel->getById($id);
            if (!$comment) {
                $this->response->json(['error' => 'Comment không tồn tại'], 404);
                return;
            }

            // Chỉ cho phép user sở hữu comment hoặc admin mới được xóa
            if ($comment['user_id'] != $user['id'] && $user['role'] != 1) {
                $this->response->json(['error' => 'Bạn không có quyền xóa comment này'], 403);
                return;
            }

            $result = $this->commentModel->delete($id);
            if ($result) {
                $this->response->json(['message' => 'Xóa comment thành công'], 200);
            } else {
                $this->response->json(['error' => 'Không thể xóa comment'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * GET /api/v1/comments/count/{postId} - Đếm số comment theo post_id
     */
    public function count($postId)
    {
        try {
            if (!is_numeric($postId)) {
                $this->response->json(['error' => 'Post ID không hợp lệ'], 400);
                return;
            }

            $count = $this->commentModel->countByPostId($postId);
            $this->response->json(['count' => $count], 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }
}

