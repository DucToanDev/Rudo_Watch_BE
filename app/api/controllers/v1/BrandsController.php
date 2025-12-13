<?php
require_once __DIR__ . '/../../../models/BrandModel.php';
require_once __DIR__ . '/../../../models/ProductModel.php';
require_once __DIR__ . '/../../../services/CloudinaryService.php';
require_once __DIR__ . '/../../../core/Response.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';

class BrandsController
{
    private $brandsModel;
    private $productsModel;
    private $storageService;
    private $response;
    private $authMiddleware;

    public function __construct()
    {
        $this->brandsModel = new Brands();
        $this->productsModel = new Products();
        $this->response = new Response();
        $this->authMiddleware = new AuthMiddleware();
        
        try {
            $this->storageService = CloudinaryService::getInstance();
        } catch (Exception $e) {
            $this->storageService = null;
        }
    }

    /**
     * Lấy danh sách thương hiệu
     */
    public function index()
    {
        try {
            $result = $this->brandsModel->getAll();
            $this->response->json($result, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Lấy thông tin thương hiệu theo ID
     */
    public function show($id)
    {
        try {
            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $brand = $this->brandsModel->getById($id);

            if (!$brand) {
                $this->response->json(['error' => 'Thương hiệu không tồn tại'], 404);
                return;
            }

            $brand['product_count'] = $this->brandsModel->countProducts($id);
            $this->response->json($brand, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Lấy thông tin thương hiệu theo slug
     */
    public function showBySlug($slug)
    {
        try {
            if (empty($slug)) {
                $this->response->json(['error' => 'Slug không hợp lệ'], 400);
                return;
            }

            $brand = $this->brandsModel->getBySlug($slug);
            if (!$brand) {
                $this->response->json(['error' => 'Thương hiệu không tồn tại'], 404);
                return;
            }

            $brand['product_count'] = $this->brandsModel->countProducts($brand['id']);
            $this->response->json($brand, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Tạo thương hiệu mới
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

            // Xử lý dữ liệu từ form-data
            if (empty($data)) {
                $data = (object)$_POST;
            } else {
                // Chuyển đổi data thành object nếu là array (JSON request)
                if (is_array($data)) {
                    $data = (object)$data;
                }
            }

            $errors = $this->validateBrandData($data, false);

            if (!empty($errors)) {
                $this->response->json(['errors' => $errors], 400);
                return;
            }

            // Xử lý upload logo
            $logoPath = null;
            if (isset($_FILES['logo']) && $_FILES['logo']['error'] === UPLOAD_ERR_OK) {
                if ($this->storageService) {
                    $uploadResult = $this->storageService->uploadFile($_FILES['logo'], 'brands');
                    if ($uploadResult['success']) {
                        $logoPath = $uploadResult['url'];
                    } else {
                        $this->response->json(['error' => 'Không thể upload logo: ' . $uploadResult['message']], 400);
                        return;
                    }
                } else {
                    $logoPath = $this->uploadLogo($_FILES['logo']);
                    if ($logoPath === false) {
                        $this->response->json(['error' => 'Không thể upload logo'], 400);
                        return;
                    }
                }
            }

            $result = $this->brandsModel->create($data, $logoPath);

            if ($result) {
                $this->response->json([
                    'message' => 'Tạo thương hiệu thành công',
                    'data' => $result
                ], 201);
            } else {
                $this->response->json(['error' => 'Không thể tạo thương hiệu'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

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

            $brand = $this->brandsModel->getById($id);
            if (!$brand) {
                $this->response->json(['error' => 'Thương hiệu không tồn tại'], 404);
                return;
            }

            // Xử lý dữ liệu từ form-data hoặc JSON
            $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
            if (strpos($contentType, 'multipart/form-data') !== false) {
                $data = (object)$_POST;
            } else {
                $data = json_decode(file_get_contents("php://input"));
            }

            if (!$data || (empty($data->name) && !isset($_FILES['logo']))) {
                $this->response->json(['error' => 'Dữ liệu không hợp lệ'], 400);
                return;
            }

            $errors = $this->validateBrandData($data, true);
            if (!empty($errors)) {
                $this->response->json(['errors' => $errors], 400);
                return;
            }

            // Xử lý upload logo
            $logoPath = null;
            if (isset($_FILES['logo']) && $_FILES['logo']['error'] === UPLOAD_ERR_OK) {
                if ($this->storageService) {
                    $uploadResult = $this->storageService->uploadFile($_FILES['logo'], 'brands');
                    if ($uploadResult['success']) {
                        $logoPath = $uploadResult['url'];
                        if (!empty($brand['logo'])) {
                            $this->storageService->deleteFile($brand['logo']);
                        }
                    } else {
                        $this->response->json(['error' => 'Không thể upload logo: ' . $uploadResult['message']], 400);
                        return;
                    }
                } else {
                    $logoPath = $this->uploadLogo($_FILES['logo']);
                    if ($logoPath === false) {
                        $this->response->json(['error' => 'Không thể upload logo'], 400);
                        return;
                    }
                    if (!empty($brand['logo'])) {
                        $oldLogoPath = __DIR__ . '/../../../../' . $brand['logo'];
                        if (file_exists($oldLogoPath)) {
                            unlink($oldLogoPath);
                        }
                    }
                }
            }

            if (!isset($data->name)) {
                $data->name = $brand['name'];
            }

            $result = $this->brandsModel->update($id, $data, $logoPath);

            if ($result) {
                $this->response->json([
                    'message' => 'Cập nhật thương hiệu thành công',
                    'data' => $result
                ], 200);
            } else {
                $this->response->json(['error' => 'Không thể cập nhật thương hiệu'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

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

            $brand = $this->brandsModel->getById($id);
            if (!$brand) {
                $this->response->json(['error' => 'Thương hiệu không tồn tại'], 404);
                return;
            }

            $productCount = $this->brandsModel->countProducts($id);
            if ($productCount > 0) {
                $confirm = isset($_GET['confirm']) && $_GET['confirm'] === 'true';

                if (!$confirm) {
                    $this->response->json([
                        'message' => 'Thương hiệu này đang có ' . $productCount . ' sản phẩm. Bạn có muốn xóa tất cả sản phẩm và thương hiệu này không?',
                        'product_count' => $productCount,
                        'requires_confirmation' => true,
                        'brand' => $brand
                    ], 200);
                    return;
                }

                $deleteResult = $this->productsModel->deleteByBrand($id);

                if (!$deleteResult) {
                    $this->response->json(['error' => 'Không thể xóa sản phẩm của thương hiệu'], 500);
                    return;
                }
            }

            $result = $this->brandsModel->delete($id);
            if ($result) {
                $message = $productCount > 0
                    ? "Đã xóa $productCount sản phẩm và thương hiệu thành công"
                    : 'Xóa thương hiệu thành công';
                $this->response->json(['message' => $message], 200);
            } else {
                $this->response->json(['error' => 'Không thể xóa thương hiệu'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    private function validateBrandData($data, $isUpdate = false)
    {
        $errors = [];

        if (!$isUpdate) {
            if (empty($data->name)) {
                $errors['name'] = 'Tên thương hiệu là bắt buộc';
            } elseif (strlen($data->name) > 255) {
                $errors['name'] = 'Tên thương hiệu không được vượt quá 255 ký tự';
            }
        } else {
            if (isset($data->name)) {
                if (empty(trim($data->name))) {
                    $errors['name'] = 'Tên thương hiệu không được để trống';
                } elseif (strlen($data->name) > 255) {
                    $errors['name'] = 'Tên thương hiệu không được vượt quá 255 ký tự';
                }
            }
        }

        if (isset($_FILES['logo']) && $_FILES['logo']['error'] === UPLOAD_ERR_OK) {
            $allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'];
            if (!in_array($_FILES['logo']['type'], $allowedTypes)) {
                $errors['logo'] = 'Chỉ chấp nhận file ảnh (JPEG, PNG, GIF, WebP, SVG)';
            }
            if ($_FILES['logo']['size'] > 2 * 1024 * 1024) {
                $errors['logo'] = 'Kích thước ảnh tối đa 2MB';
            }
        }

        return $errors;
    }

    private function uploadLogo($file)
    {
        $uploadDir = __DIR__ . '/../../../../uploads/brands/';

        // Tạo thư mục nếu chưa tồn tại
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }

        // Tạo tên file duy nhất
        $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
        $filename = 'brand_' . time() . '_' . uniqid() . '.' . $extension;
        $targetPath = $uploadDir . $filename;

        if (move_uploaded_file($file['tmp_name'], $targetPath)) {
            return 'uploads/brands/' . $filename;
        }

        return false;
    }


    /**
     * Lấy danh sách thương hiệu đang hoạt động
     */
    public function active()
    {
        try {
            $brands = $this->brandsModel->getActive();
            $this->response->json([
                'success' => true,
                'data' => $brands
            ], 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }
}
