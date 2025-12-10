<?php
require_once __DIR__ . '/../../../models/PostModel.php';
require_once __DIR__ . '/../../../models/PostCategoryModel.php';
require_once __DIR__ . '/../../../services/RailwayStorageService.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../../../core/Response.php';

class PostsController
{
    private $postModel;
    private $postCategoryModel;
    private $storageService;
    private $authMiddleware;
    private $response;

    public function __construct()
    {
        $this->postModel = new Posts();
        $this->postCategoryModel = new PostCategories();
        $this->authMiddleware = new AuthMiddleware();
        $this->response = new Response();
        
        // Khởi tạo Railway Storage Service
        try {
            $this->storageService = new RailwayStorageService();
        } catch (Exception $e) {
            // Nếu không cấu hình Railway S3, sẽ dùng local storage
            $this->storageService = null;
        }
    }

    /**
     * GET /api/v1/posts
     * Lấy danh sách bài viết (có thể lọc theo category_id)
     */
    public function index()
    {
        try {
            $params = [
                'category_id' => $_GET['category_id'] ?? ''
            ];

            // Loại bỏ các tham số rỗng
            $params = array_filter($params, function ($value) {
                return $value !== '';
            });

            $posts = $this->postModel->getAll($params);
            $this->response->json($posts, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * GET /api/v1/posts/{id}
     * Lấy chi tiết bài viết theo ID hoặc slug
     */
    public function show($id)
    {
        try {
            // Kiểm tra nếu là số thì tìm theo ID, nếu không thì tìm theo slug
            if (is_numeric($id)) {
                $post = $this->postModel->getById($id);
            } else {
                $post = $this->postModel->getBySlug($id);
            }

            if (!$post) {
                $this->response->json(['error' => 'Bài viết không tồn tại'], 404);
                return;
            }

            $this->response->json($post, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * POST /api/v1/posts
     * Tạo bài viết mới
     */
    public function store($data)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        try {
            // Kiểm tra nếu có file upload (multipart/form-data)
            if (!empty($_FILES['featured_image']) || !empty($_POST)) {
                $data = (object) $_POST;
            } else {
                // Chuyển đổi data thành object nếu là array (JSON request)
                if (is_array($data)) {
                    $data = (object)$data;
                }
            }

            $errors = $this->validatePostData($data, false);
            if (!empty($errors)) {
                $this->response->json(['errors' => $errors], 400);
                return;
            }

            // Kiểm tra category tồn tại
            $category = $this->postCategoryModel->getById($data->post_category_id);
            if (!$category) {
                $this->response->json(['error' => 'Danh mục không tồn tại'], 400);
                return;
            }

            // Tạo slug nếu chưa có
            if (empty($data->slug)) {
                $slug = create_slug($data->name);
            } else {
                $slug = create_slug($data->slug);
            }

            // Kiểm tra slug đã tồn tại chưa
            $existing = $this->postModel->getBySlug($slug);
            if ($existing) {
                $this->response->json(['error' => 'Slug đã tồn tại'], 400);
                return;
            }

            // Upload ảnh đại diện nếu có
            $image = null;
            if (!empty($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
                // Sử dụng Railway S3 nếu có
                if ($this->storageService) {
                    $uploadResult = $this->storageService->uploadFile($_FILES['image'], 'posts');
                    if ($uploadResult['success']) {
                        $image = $uploadResult['url'];
                    } else {
                        $this->response->json(['error' => 'Không thể upload ảnh: ' . $uploadResult['message']], 400);
                        return;
                    }
                } else {
                    // Fallback: upload local (nếu cần)
                    $this->response->json(['error' => 'Chưa cấu hình storage service'], 500);
                    return;
                }
            }

            // Set user_id từ user đăng nhập
            $data->user_id = $user['id'];

            $result = $this->postModel->create($data, $image);

            if ($result) {
                $this->response->json([
                    'message' => 'Tạo bài viết thành công',
                    'data' => $result
                ], 201);
            } else {
                $this->response->json(['error' => 'Không thể tạo bài viết'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * PUT /api/v1/posts/{id}
     * Cập nhật bài viết
     */
    public function update($id)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        try {
            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $existingPost = $this->postModel->getById($id);
            if (!$existingPost) {
                $this->response->json(['error' => 'Bài viết không tồn tại'], 404);
                return;
            }


            // Kiểm tra nếu có file upload (multipart/form-data)
            if (!empty($_FILES['featured_image']) || !empty($_POST)) {
                $data = (object) $_POST;
            } else {
                $data = json_decode(file_get_contents("php://input"));
            }

            if (!$data) {
                $this->response->json(['error' => 'Dữ liệu không hợp lệ'], 400);
                return;
            }

            $errors = $this->validatePostData($data, true);
            if (!empty($errors)) {
                $this->response->json(['errors' => $errors], 400);
                return;
            }

            // Kiểm tra category nếu có thay đổi
            if (isset($data->post_category_id)) {
                $category = $this->postCategoryModel->getById($data->post_category_id);
                if (!$category) {
                    $this->response->json(['error' => 'Danh mục không tồn tại'], 400);
                    return;
                }
            }

            // Tạo slug nếu có thay đổi
            $slug = $existingPost['slug'];
            if (isset($data->name) && $data->name !== $existingPost['name']) {
                $slug = create_slug($data->name);
            } elseif (isset($data->slug)) {
                $slug = create_slug($data->slug);
            }

            // Kiểm tra slug đã tồn tại chưa (trừ chính nó)
            if ($slug !== $existingPost['slug']) {
                $existing = $this->postModel->getBySlug($slug);
                if ($existing && $existing['id'] != $id) {
                    $this->response->json(['error' => 'Slug đã tồn tại'], 400);
                    return;
                }
            }

            // Upload ảnh mới nếu có
            $image = null;
            if (!empty($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
                // Sử dụng Railway S3 nếu có
                if ($this->storageService) {
                    $uploadResult = $this->storageService->uploadFile($_FILES['image'], 'posts');
                    if ($uploadResult['success']) {
                        $image = $uploadResult['url'];
                        // Xóa ảnh cũ từ S3 nếu có
                        if (!empty($existingPost['image'])) {
                            $oldKey = $this->extractS3Key($existingPost['image']);
                            if ($oldKey) {
                                $this->storageService->deleteFile($oldKey);
                            }
                        }
                    } else {
                        $this->response->json(['error' => 'Không thể upload ảnh: ' . $uploadResult['message']], 400);
                        return;
                    }
                }
            }

            $result = $this->postModel->update($id, $data, $image);

            if ($result) {
                $this->response->json([
                    'message' => 'Cập nhật bài viết thành công',
                    'data' => $result
                ], 200);
            } else {
                $this->response->json(['error' => 'Không thể cập nhật bài viết'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * DELETE /api/v1/posts/{id}
     * Xóa bài viết
     */
    public function destroy($id)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        try {
            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $post = $this->postModel->getById($id);
            if (!$post) {
                $this->response->json(['error' => 'Bài viết không tồn tại'], 404);
                return;
            }


            // Xóa ảnh từ S3 nếu có
            if (!empty($post['image']) && $this->storageService) {
                $oldKey = $this->extractS3Key($post['image']);
                if ($oldKey) {
                    $this->storageService->deleteFile($oldKey);
                }
            }

            $result = $this->postModel->delete($id);

            if ($result) {
                $this->response->json(['message' => 'Xóa bài viết thành công'], 200);
            } else {
                $this->response->json(['error' => 'Không thể xóa bài viết'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }


    /**
     * Validate dữ liệu bài viết
     */
    private function validatePostData($data, $isUpdate = false)
    {
        $errors = [];

        if (!$isUpdate) {
            if (empty($data->name)) {
                $errors['name'] = 'Tên bài viết là bắt buộc';
            }
            if (empty($data->content)) {
                $errors['content'] = 'Nội dung là bắt buộc';
            }
            if (empty($data->post_category_id) || !is_numeric($data->post_category_id)) {
                $errors['post_category_id'] = 'Danh mục là bắt buộc và phải là số';
            }
        } else {
            if (isset($data->name) && empty($data->name)) {
                $errors['name'] = 'Tên bài viết không được để trống';
            }
            if (isset($data->content) && empty($data->content)) {
                $errors['content'] = 'Nội dung không được để trống';
            }
            if (isset($data->post_category_id) && (!is_numeric($data->post_category_id) || $data->post_category_id <= 0)) {
                $errors['post_category_id'] = 'Danh mục phải là số hợp lệ';
            }
        }

        return $errors;
    }

    /**
     * Extract S3 key từ URL
     */
    private function extractS3Key($url)
    {
        // URL format: https://storage.railway.app/{bucket}/{key}
        if (preg_match('/\/' . preg_quote($_ENV['RAILWAY_S3_BUCKET'] ?? $_ENV['AWS_S3_BUCKET_NAME'] ?? '', '/') . '\/(.+)$/', $url, $matches)) {
            return $matches[1];
        }
        return null;
    }
}

