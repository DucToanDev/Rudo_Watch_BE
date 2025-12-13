<?php
require_once __DIR__ . '/../../../services/CloudinaryService.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../../../core/Response.php';

class UploadController
{
    private $storageService;
    private $authMiddleware;
    private $response;

    public function __construct()
    {
        try {
            $this->storageService = CloudinaryService::getInstance();
        } catch (Exception $e) {
            $this->storageService = null;
        }
        $this->authMiddleware = new AuthMiddleware();
        $this->response = new Response();
    }

    /**
     * POST /api/v1/upload/image
     * Upload một ảnh lên Cloudinary
     */
    public function image()
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        // Kiểm tra quyền admin
        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        // Kiểm tra Cloudinary đã được cấu hình chưa
        if (!$this->storageService) {
            $this->response->json([
                'error' => 'Cloudinary chưa được cấu hình'
            ], 500);
            return;
        }

        if (empty($_FILES['image'])) {
            $this->response->json(['error' => 'Không có file được upload'], 400);
            return;
        }

        $file = $_FILES['image'];

        // Validate file
        $validation = $this->storageService->validateImage($file);
        if (!$validation['valid']) {
            $this->response->json(['error' => $validation['message']], 400);
            return;
        }

        // Lấy folder từ request (mặc định là 'uploads')
        $folder = $_POST['folder'] ?? 'uploads';

        // Upload file
        $result = $this->storageService->uploadFile($file, $folder);

        if ($result['success']) {
            $this->response->json([
                'message' => 'Upload thành công',
                'data' => [
                    'url' => $result['url'],
                    'secure_url' => $result['secure_url'],
                    'public_id' => $result['public_id'],
                    'format' => $result['format'] ?? null,
                    'width' => $result['width'] ?? null,
                    'height' => $result['height'] ?? null
                ]
            ], 200);
        } else {
            $this->response->json(['error' => $result['message']], 500);
        }
    }

    /**
     * POST /api/v1/upload/images
     * Upload nhiều ảnh lên Cloudinary
     */
    public function images()
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        // Kiểm tra quyền admin
        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        // Kiểm tra Cloudinary đã được cấu hình chưa
        if (!$this->storageService) {
            $this->response->json([
                'error' => 'Cloudinary chưa được cấu hình'
            ], 500);
            return;
        }

        if (empty($_FILES['images'])) {
            $this->response->json(['error' => 'Không có file được upload'], 400);
            return;
        }

        $files = $_FILES['images'];
        $folder = $_POST['folder'] ?? 'uploads';

        // Xử lý multiple files
        $uploadedFiles = [];
        $errors = [];

        if (is_array($files['name'])) {
            // Multiple files
            $fileCount = count($files['name']);
            for ($i = 0; $i < $fileCount; $i++) {
                $file = [
                    'name' => $files['name'][$i],
                    'type' => $files['type'][$i],
                    'tmp_name' => $files['tmp_name'][$i],
                    'error' => $files['error'][$i],
                    'size' => $files['size'][$i]
                ];

                if ($file['error'] === UPLOAD_ERR_OK) {
                    $validation = $this->storageService->validateImage($file);
                    if ($validation['valid']) {
                        $result = $this->storageService->uploadFile($file, $folder);
                        if ($result['success']) {
                            $uploadedFiles[] = [
                                'url' => $result['url'],
                                'secure_url' => $result['secure_url'],
                                'public_id' => $result['public_id']
                            ];
                        } else {
                            $errors[] = $file['name'] . ': ' . $result['message'];
                        }
                    } else {
                        $errors[] = $file['name'] . ': ' . $validation['message'];
                    }
                }
            }
        } else {
            // Single file
            $validation = $this->storageService->validateImage($files);
            if ($validation['valid']) {
                $result = $this->storageService->uploadFile($files, $folder);
                if ($result['success']) {
                    $uploadedFiles[] = [
                        'url' => $result['url'],
                        'secure_url' => $result['secure_url'],
                        'public_id' => $result['public_id']
                    ];
                } else {
                    $errors[] = $result['message'];
                }
            } else {
                $errors[] = $validation['message'];
            }
        }

        $this->response->json([
            'message' => 'Upload hoàn tất',
            'data' => [
                'uploaded' => $uploadedFiles,
                'errors' => $errors,
                'total' => count($uploadedFiles),
                'failed' => count($errors)
            ]
        ], 200);
    }

    // DELETE /api/v1/upload/{publicId}
    public function delete($publicId)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        // Kiểm tra quyền admin
        if (!$this->authMiddleware->requireAdmin($user)) {
            return;
        }

        // Kiểm tra Cloudinary đã được cấu hình chưa
        if (!$this->storageService) {
            $this->response->json([
                'error' => 'Cloudinary chưa được cấu hình'
            ], 500);
            return;
        }

        // Decode URL nếu cần
        $publicId = urldecode($publicId);

        $result = $this->storageService->deleteFile($publicId);

        if ($result['success']) {
            $this->response->json(['message' => $result['message']], 200);
        } else {
            $this->response->json(['error' => $result['message']], 500);
        }
    }
}