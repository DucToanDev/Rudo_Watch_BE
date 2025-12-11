<?php
require_once __DIR__ . '/../../../models/ProductVariantModel.php';
require_once __DIR__ . '/../../../services/CloudinaryService.php';
require_once __DIR__ . '/../../../core/Response.php';

class ProductVariantsController
{
    private $variantModel;
    private $storageService;
    private $response;
    private $uploadDir = __DIR__ . '/../../../../uploads/products/';

    public function __construct()
    {
        $this->variantModel = new ProductVariants();
        $this->response = new Response();
        
        // Khởi tạo Cloudinary Service
        try {
            $this->storageService = CloudinaryService::getInstance();
        } catch (Exception $e) {
            $this->storageService = null;
        }

        // Tạo thư mục uploads nếu chưa có (fallback)
        if (!is_dir($this->uploadDir)) {
            mkdir($this->uploadDir, 0755, true);
        }
    }

    // GET /api/v1/product-variants - Lấy tất cả variants
    public function index()
    {
        try {
            $variants = $this->variantModel->getAll();
            $this->response->json([
                'success' => true,
                'data' => $variants
            ], 200);
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => 'Lỗi: ' . $e->getMessage()
            ], 500);
        }
    }

    // GET /api/v1/product-variants/product/:id - Lấy variants theo product_id
    public function byProduct($productId)
    {
        try {
            if (!is_numeric($productId)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Product ID không hợp lệ'
                ], 400);
                return;
            }

            $variants = $this->variantModel->getByProductId($productId);

            $this->response->json([
                'success' => true,
                'data' => $variants
            ], 200);
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => 'Lỗi: ' . $e->getMessage()
            ], 500);
        }
    }

    // GET /api/v1/product-variants/:id - Lấy variant theo ID
    public function show($id)
    {
        try {
            if (!is_numeric($id)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'ID không hợp lệ'
                ], 400);
                return;
            }

            $variant = $this->variantModel->getById($id);

            if (!$variant) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Variant không tồn tại'
                ], 404);
                return;
            }

            $this->response->json([
                'success' => true,
                'data' => $variant
            ], 200);
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => 'Lỗi: ' . $e->getMessage()
            ], 500);
        }
    }

    // POST /api/v1/product-variants - Tạo variant mới
    public function store($data)
    {
        try {
            // Kiểm tra nếu có file upload (multipart/form-data)
            if (!empty($_FILES['image']) || !empty($_POST)) {
                $data = (object) $_POST;
            } else {
                // Chuyển đổi data thành object nếu là array (JSON request)
                if (is_array($data)) {
                    $data = (object)$data;
                }
            }

            // Validate input
            if (empty($data->product_id) || empty($data->price)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'product_id và price là bắt buộc'
                ], 400);
                return;
            }

            if (!is_numeric($data->product_id) || !is_numeric($data->price)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'product_id và price phải là số'
                ], 400);
                return;
            }

            if ($data->price < 0) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Giá không thể âm'
                ], 400);
                return;
            }

            if (isset($data->quantity) && $data->quantity < 0) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Số lượng không thể âm'
                ], 400);
                return;
            }

            // Upload ảnh nếu có
            $imagePath = null;
            if (!empty($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
                // Sử dụng Railway S3 nếu có
                if ($this->storageService) {
                    $uploadResult = $this->storageService->uploadFile($_FILES['image'], 'products/variants');
                    if ($uploadResult['success']) {
                        $imagePath = $uploadResult['url'];
                    } else {
                        $this->response->json([
                            'success' => false,
                            'error' => 'Không thể upload ảnh: ' . $uploadResult['message']
                        ], 400);
                        return;
                    }
                } else {
                    // Fallback: upload local
                    $imagePath = $this->uploadImage($_FILES['image']);
                    if (!$imagePath) {
                        $this->response->json([
                            'success' => false,
                            'error' => 'Không thể upload ảnh. Chỉ chấp nhận jpeg, png, gif, webp và tối đa 5MB'
                        ], 400);
                        return;
                    }
                }
            }

            $result = $this->variantModel->create($data, $imagePath);

            if ($result['success']) {
                $this->response->json([
                    'success' => true,
                    'message' => $result['message'],
                    'data' => $result['variant']
                ], 201);
            } else {
                $this->response->json([
                    'success' => false,
                    'error' => $result['message']
                ], 400);
            }
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => 'Lỗi: ' . $e->getMessage()
            ], 500);
        }
    }

    // PUT /api/v1/product-variants/:id - Cập nhật variant
    public function update($id)
    {
        try {
            if (!is_numeric($id)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'ID không hợp lệ'
                ], 400);
                return;
            }

            // Lấy variant hiện tại để xóa ảnh cũ nếu cần
            $existingVariant = $this->variantModel->getById($id);
            if (!$existingVariant) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Variant không tồn tại'
                ], 404);
                return;
            }

            // Kiểm tra nếu có file upload (multipart/form-data)
            if (!empty($_FILES['image']) || !empty($_POST)) {
                $data = (object) $_POST;
            } else {
                $data = json_decode(file_get_contents("php://input"));
            }

            if (isset($data->price) && !is_numeric($data->price)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'price phải là số'
                ], 400);
                return;
            }

            if (isset($data->price) && $data->price < 0) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Giá không thể âm'
                ], 400);
                return;
            }

            if (isset($data->quantity) && !is_numeric($data->quantity)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'quantity phải là số'
                ], 400);
                return;
            }

            if (isset($data->quantity) && $data->quantity < 0) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Số lượng không thể âm'
                ], 400);
                return;
            }

            if (isset($data->product_id) && !is_numeric($data->product_id)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'product_id phải là số'
                ], 400);
                return;
            }

            // Upload ảnh mới nếu có
            $imagePath = null;
            if (!empty($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
                // Sử dụng Railway S3 nếu có
                if ($this->storageService) {
                    $uploadResult = $this->storageService->uploadFile($_FILES['image'], 'products/variants');
                    if ($uploadResult['success']) {
                        $imagePath = $uploadResult['url'];
                        // Xóa ảnh cũ từ S3 nếu có
                        if (!empty($existingVariant['image'])) {
                            $oldKey = $this->extractS3Key($existingVariant['image']);
                            if ($oldKey) {
                                $this->storageService->deleteFile($oldKey);
                            }
                        }
                    } else {
                        $this->response->json([
                            'success' => false,
                            'error' => 'Không thể upload ảnh: ' . $uploadResult['message']
                        ], 400);
                        return;
                    }
                } else {
                    // Fallback: upload local
                    $imagePath = $this->uploadImage($_FILES['image']);
                    if (!$imagePath) {
                        $this->response->json([
                            'success' => false,
                            'error' => 'Không thể upload ảnh. Chỉ chấp nhận jpeg, png, gif, webp và tối đa 5MB'
                        ], 400);
                        return;
                    }
                    // Xóa ảnh cũ nếu có
                    if (!empty($existingVariant['image'])) {
                        $this->deleteImage($existingVariant['image']);
                    }
                }
            }

            $result = $this->variantModel->update($id, $data, $imagePath);

            if ($result['success']) {
                $this->response->json([
                    'success' => true,
                    'message' => $result['message'],
                    'data' => $result['variant']
                ], 200);
            } else {
                $this->response->json([
                    'success' => false,
                    'error' => $result['message']
                ], 400);
            }
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => 'Lỗi: ' . $e->getMessage()
            ], 500);
        }
    }

    // DELETE /api/v1/product-variants/:id - Xóa variant
    public function destroy($id)
    {
        try {
            if (!is_numeric($id)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'ID không hợp lệ'
                ], 400);
                return;
            }

            $result = $this->variantModel->delete($id);

            if ($result['success']) {
                $this->response->json([
                    'success' => true,
                    'message' => $result['message']
                ], 200);
            } else {
                $this->response->json([
                    'success' => false,
                    'error' => $result['message']
                ], 400);
            }
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => 'Lỗi: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Upload ảnh variant
     */
    private function uploadImage($file, $prefix = 'variant_')
    {
        $allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        $maxSize = 5 * 1024 * 1024; // 5MB

        // Kiểm tra loại file
        if (!in_array($file['type'], $allowedTypes)) {
            return null;
        }

        // Kiểm tra kích thước
        if ($file['size'] > $maxSize) {
            return null;
        }

        // Tạo tên file unique
        $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
        $filename = $prefix . time() . '_' . uniqid() . '.' . $extension;
        $targetPath = $this->uploadDir . $filename;

        // Upload file
        if (move_uploaded_file($file['tmp_name'], $targetPath)) {
            return 'uploads/products/' . $filename;
        }

        return null;
    }

    /**
     * Xóa ảnh cũ
     */
    private function deleteImage($imagePath)
    {
        if (empty($imagePath)) return;

        // Nếu là URL từ S3, xóa từ S3
        if ($this->storageService && strpos($imagePath, 'http') === 0) {
            $key = $this->extractS3Key($imagePath);
            if ($key) {
                $this->storageService->deleteFile($key);
            }
        } else {
            // Xóa file local
            $fullPath = __DIR__ . '/../../../../' . $imagePath;
            if (file_exists($fullPath)) {
                unlink($fullPath);
            }
        }
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
