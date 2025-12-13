<?php
require_once __DIR__ . '/../../../models/PostCategoryModel.php';
require_once __DIR__ . '/../../../core/Response.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';

class PostCategoriesController
{
    private $postCategoryModel;
    private $response;
    private $authMiddleware;

    public function __construct()
    {
        $this->postCategoryModel = new PostCategories();
        $this->response = new Response();
        $this->authMiddleware = new AuthMiddleware();
    }

    /**
     * GET /api/v1/post-categories
     * Lấy danh sách danh mục bài viết
     */
    public function index()
    {
        try {
            $categories = $this->postCategoryModel->getAll();
            $this->response->json($categories, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * GET /api/v1/post-categories/{id}
     * Lấy chi tiết danh mục bài viết
     */
    public function show($id)
    {
        try {
            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $category = $this->postCategoryModel->getById($id);

            if (!$category) {
                $this->response->json(['error' => 'Danh mục không tồn tại'], 404);
                return;
            }

            // Thêm số lượng bài viết
            $category['post_count'] = $this->postCategoryModel->countPosts($id);
            $this->response->json($category, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * POST /api/v1/post-categories
     * Tạo danh mục bài viết mới
     */
    public function store($data)
    {
        try {
            // Xác thực và kiểm tra quyền admin
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }
            
            if (!$this->authMiddleware->requireAdmin($user)) {
                return;
            }

            if (empty($data)) {
                $data = json_decode(file_get_contents("php://input"));
            }

            // Chuyển đổi data thành object nếu là array
            if (is_array($data)) {
                $data = (object)$data;
            }

            $errors = $this->validateCategoryData($data, false);
            if (!empty($errors)) {
                $this->response->json(['errors' => $errors], 400);
                return;
            }

            // Tạo slug nếu chưa có
            if (empty($data->slug)) {
                $slug = create_slug($data->name);
            } else {
                $slug = create_slug($data->slug);
            }

            // Kiểm tra slug đã tồn tại chưa
            $existing = $this->postCategoryModel->getBySlug($slug);
            if ($existing) {
                $this->response->json(['error' => 'Slug đã tồn tại'], 400);
                return;
            }

            $result = $this->postCategoryModel->create(
                $data->name,
                $slug
            );

            if ($result) {
                $this->response->json([
                    'message' => 'Tạo danh mục bài viết thành công',
                    'data' => $result
                ], 201);
            } else {
                $this->response->json(['error' => 'Không thể tạo danh mục'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * PUT /api/v1/post-categories/{id}
     * Cập nhật danh mục bài viết
     */
    public function update($id)
    {
        try {
            // Xác thực và kiểm tra quyền admin
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }
            
            if (!$this->authMiddleware->requireAdmin($user)) {
                return;
            }

            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $category = $this->postCategoryModel->getById($id);
            if (!$category) {
                $this->response->json(['error' => 'Danh mục không tồn tại'], 404);
                return;
            }

            $data = json_decode(file_get_contents("php://input"));
            if (!$data) {
                $this->response->json(['error' => 'Dữ liệu không hợp lệ'], 400);
                return;
            }

            $errors = $this->validateCategoryData($data, true);
            if (!empty($errors)) {
                $this->response->json(['errors' => $errors], 400);
                return;
            }

            // Tạo slug nếu có thay đổi
            $slug = $category['slug'];
            if (isset($data->name) && $data->name !== $category['name']) {
                $slug = create_slug($data->name);
            } elseif (isset($data->slug)) {
                $slug = create_slug($data->slug);
            }

            // Kiểm tra slug đã tồn tại chưa (trừ chính nó)
            if ($slug !== $category['slug']) {
                $existing = $this->postCategoryModel->getBySlug($slug);
                if ($existing && $existing['id'] != $id) {
                    $this->response->json(['error' => 'Slug đã tồn tại'], 400);
                    return;
                }
            }

            $result = $this->postCategoryModel->update(
                $id,
                $data->name ?? $category['name'],
                $slug
            );

            if ($result) {
                $this->response->json([
                    'message' => 'Cập nhật danh mục thành công',
                    'data' => $result
                ], 200);
            } else {
                $this->response->json(['error' => 'Không thể cập nhật danh mục'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * DELETE /api/v1/post-categories/{id}
     * Xóa danh mục bài viết
     */
    public function destroy($id)
    {
        try {
            // Xác thực và kiểm tra quyền admin
            $user = $this->authMiddleware->authenticate();
            if (!$user) {
                return;
            }
            
            if (!$this->authMiddleware->requireAdmin($user)) {
                return;
            }

            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $category = $this->postCategoryModel->getById($id);
            if (!$category) {
                $this->response->json(['error' => 'Danh mục không tồn tại'], 404);
                return;
            }

            $result = $this->postCategoryModel->delete($id);

            if ($result) {
                $this->response->json(['message' => 'Xóa danh mục thành công'], 200);
            } else {
                $this->response->json(['error' => 'Không thể xóa danh mục'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * GET /api/v1/post-categories/active
     * Lấy danh sách danh mục đang active
     */
    public function active()
    {
        try {
            $categories = $this->postCategoryModel->getActive();
            $this->response->json([
                'success' => true,
                'data' => $categories
            ], 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Validate dữ liệu danh mục
     */
    private function validateCategoryData($data, $isUpdate = false)
    {
        $errors = [];

        if (!$isUpdate) {
            if (empty($data->name)) {
                $errors['name'] = 'Tên danh mục là bắt buộc';
            }
        } else {
            if (isset($data->name) && empty($data->name)) {
                $errors['name'] = 'Tên danh mục không được để trống';
            }
        }


        return $errors;
    }
}

