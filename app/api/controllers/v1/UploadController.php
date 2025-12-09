<?php
require_once __DIR__ . '/../../../services/RailwayStorageService.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../../../core/Response.php';

class UploadController
{
    private $storageService;
    private $authMiddleware;
    private $response;

    public function __construct()
    {
        $this->storageService = new RailwayStorageService();
        $this->authMiddleware = new AuthMiddleware();
        $this->response = new Response();
    }

    /**
     * POST /api/v1/upload/image
     * Upload một ảnh lên Railway S3
     */
    public function image()
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
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
                    'key' => $result['key'],
                    'bucket' => $result['bucket']
                ]
            ], 200);
        } else {
            $this->response->json(['error' => $result['message']], 500);
        }
    }

    /**
     * POST /api/v1/upload/images
     * Upload nhiều ảnh lên Railway S3
     */
    public function images()
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
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
                                'key' => $result['key']
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
                        'key' => $result['key']
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

    /**
     * DELETE /api/v1/upload/{key}
     * Xóa file từ Railway S3
     */
    public function delete($key)
    {
        $user = $this->authMiddleware->authenticate();
        if (!$user) {
            return;
        }

        // Decode URL nếu cần
        $key = urldecode($key);

        $result = $this->storageService->deleteFile($key);

        if ($result['success']) {
            $this->response->json(['message' => $result['message']], 200);
        } else {
            $this->response->json(['error' => $result['message']], 500);
        }
    }
}

