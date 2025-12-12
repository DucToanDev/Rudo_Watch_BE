<?php

require_once __DIR__ . '/../../vendor/autoload.php';

use Cloudinary\Cloudinary;
use Cloudinary\Configuration\Configuration;
use Cloudinary\Api\Upload\UploadApi;

class CloudinaryService
{
    private static $instance = null;
    private $cloudinary;
    private $uploadApi;

    public static function getInstance()
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    private function __construct()
    {
        // Lấy cấu hình từ environment (đã được load toàn cục trong index.php)
        $cloudName = getenv('CLOUDINARY_CLOUD_NAME') ?: ($_ENV['CLOUDINARY_CLOUD_NAME'] ?? '');
        $apiKey = getenv('CLOUDINARY_API_KEY') ?: ($_ENV['CLOUDINARY_API_KEY'] ?? '');
        $apiSecret = getenv('CLOUDINARY_API_SECRET') ?: ($_ENV['CLOUDINARY_API_SECRET'] ?? '');

        if (empty($cloudName) || empty($apiKey) || empty($apiSecret)) {
            throw new Exception('Thiếu cấu hình Cloudinary.');
        }

        // Set biến môi trường cho Cloudinary SDK (SDK có thể đọc từ đây)
        putenv("CLOUDINARY_URL=cloudinary://{$apiKey}:{$apiSecret}@{$cloudName}");
        $_ENV['CLOUDINARY_URL'] = "cloudinary://{$apiKey}:{$apiSecret}@{$cloudName}";

        // Cấu hình Cloudinary
        try {
            Configuration::instance([
                'cloud' => [
                    'cloud_name' => $cloudName,
                    'api_key' => $apiKey,
                    'api_secret' => $apiSecret
                ],
                'url' => [
                    'secure' => true
                ]
            ]);
        } catch (\Exception $e) {
            throw new Exception('Không thể khởi tạo Cloudinary: ' . $e->getMessage());
        }

        $this->cloudinary = new Cloudinary();
        $this->uploadApi = new UploadApi();
    }


    public function uploadFile($filePath, $folder = 'uploads', $publicId = null, $options = [])
    {
        try {
            $fileToUpload = null;
            $originalName = null;

            // Xử lý file upload từ $_FILES
            if (is_array($filePath)) {
                $tmpFile = $filePath['tmp_name'];
                $originalName = $filePath['name'];
                
                if (!file_exists($tmpFile)) {
                    return [
                        'success' => false,
                        'message' => 'File không tồn tại'
                    ];
                }

                $fileToUpload = $tmpFile;
            } else {
                // File path từ local
                if (!file_exists($filePath)) {
                    return [
                        'success' => false,
                        'message' => 'File không tồn tại'
                    ];
                }

                $fileToUpload = $filePath;
                $originalName = basename($filePath);
            }

            // Tạo public_id nếu chưa có
            if (!$publicId) {
                $extension = pathinfo($originalName, PATHINFO_EXTENSION);
                $publicId = $this->generatePublicId($extension);
            }

            // Chuẩn bị options cho Cloudinary
            $uploadOptions = array_merge([
                'public_id' => $publicId,
                'folder' => $folder,
                'resource_type' => 'auto', // Tự động phát hiện loại file (image, video, etc.)
                'overwrite' => false, // Không ghi đè file có cùng public_id
                'invalidate' => true, // Xóa cache CDN
            ], $options);

            // Upload lên Cloudinary
            $result = $this->uploadApi->upload($fileToUpload, $uploadOptions);

            return [
                'success' => true,
                'url' => $result['secure_url'] ?? $result['url'],
                'secure_url' => $result['secure_url'] ?? $result['url'],
                'public_id' => $result['public_id'],
                'format' => $result['format'] ?? null,
                'width' => $result['width'] ?? null,
                'height' => $result['height'] ?? null,
                'bytes' => $result['bytes'] ?? null,
                'resource_type' => $result['resource_type'] ?? 'image'
            ];
        } catch (\Cloudinary\Api\Exception\ApiError $e) {
            return [
                'success' => false,
                'message' => 'Lỗi upload Cloudinary: ' . $e->getMessage()
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Upload nhiều file
     */
    public function uploadFiles($files, $folder = 'uploads', $options = [])
    {
        $results = [];
        
        foreach ($files as $file) {
            $result = $this->uploadFile($file, $folder, null, $options);
            $results[] = $result;
        }

        return $results;
    }


    public function deleteFile($publicId, $options = [])
    {
        try {
            // Nếu là URL Cloudinary, extract public_id
            if (strpos($publicId, 'http') === 0) {
                $publicId = $this->extractPublicIdFromUrl($publicId);
                if (!$publicId) {
                    return [
                        'success' => false,
                        'message' => 'Không thể extract public_id từ URL'
                    ];
                }
            }

            $deleteOptions = array_merge([
                'resource_type' => 'image', // Mặc định là image
                'invalidate' => true, // Xóa cache CDN
            ], $options);

            $result = $this->uploadApi->destroy($publicId, $deleteOptions);

            if ($result['result'] === 'ok') {
                return [
                    'success' => true,
                    'message' => 'Xóa file thành công'
                ];
            } else {
                return [
                    'success' => false,
                    'message' => 'Không thể xóa file: ' . ($result['result'] ?? 'unknown error')
                ];
            }
        } catch (\Cloudinary\Api\Exception\ApiError $e) {
            return [
                'success' => false,
                'message' => 'Lỗi xóa file: ' . $e->getMessage()
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Kiểm tra file có tồn tại không
     */
    public function fileExists($publicId, $options = [])
    {
        try {
            $checkOptions = array_merge([
                'resource_type' => 'image',
            ], $options);

            $result = $this->uploadApi->explicit($publicId, $checkOptions);
            return !empty($result);
        } catch (Exception $e) {
            return false;
        }
    }

    /**
     * Lấy URL của file từ public_id
     */
    public function getUrl($publicId, $options = [])
    {
        try {
            $urlOptions = array_merge([
                'secure' => true,
            ], $options);

            return $this->cloudinary->image($publicId)->secure($urlOptions['secure'])->toUrl();
        } catch (Exception $e) {
            return null;
        }
    }


    public function getTransformedUrl($publicId, $transformations = [])
    {
        try {
            $img = $this->cloudinary->image($publicId);

            // Áp dụng các transformations
            if (isset($transformations['width'])) {
                $img->resize(\Cloudinary\Transformation\Resize::scale()->width($transformations['width']));
            }
            if (isset($transformations['height'])) {
                $img->resize(\Cloudinary\Transformation\Resize::scale()->height($transformations['height']));
            }
            if (isset($transformations['crop'])) {
                $img->resize(\Cloudinary\Transformation\Resize::fill()->width($transformations['width'] ?? 300)->height($transformations['height'] ?? 300));
            }
            if (isset($transformations['quality'])) {
                $img->delivery(\Cloudinary\Transformation\Delivery::quality($transformations['quality']));
            }
            if (isset($transformations['format'])) {
                $img->delivery(\Cloudinary\Transformation\Delivery::format($transformations['format']));
            }

            return $img->secure()->toUrl();
        } catch (Exception $e) {
            return null;
        }
    }

    /**
     * Tạo tên file unique
     */
    private function generatePublicId($extension)
    {
        $timestamp = time();
        $random = bin2hex(random_bytes(8));
        return $timestamp . '_' . $random;
    }

    /**
     * Extract public_id từ Cloudinary URL
     */
    private function extractPublicIdFromUrl($url)
    {

        if (preg_match('/\/upload\/[^\/]*\/(.+?)\.(jpg|jpeg|png|gif|webp|mp4|pdf|zip|etc)$/i', $url, $matches)) {
            return $matches[1];
        }
        
        // Fallback: thử extract từ path
        $path = parse_url($url, PHP_URL_PATH);
        if ($path) {
            $parts = explode('/', trim($path, '/'));
            // Tìm phần cuối cùng (public_id + extension)
            if (count($parts) > 0) {
                $lastPart = end($parts);
                return pathinfo($lastPart, PATHINFO_FILENAME);
            }
        }
        
        return null;
    }

    /**
     * Validate file type
     */
    public function validateImage($file)
    {
        $allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
        $maxSize = 10 * 1024 * 1024; // 10MB (Cloudinary hỗ trợ file lớn hơn)

        if (is_array($file)) {
            $mimeType = $file['type'] ?? mime_content_type($file['tmp_name']);
            $size = $file['size'] ?? 0;
        } else {
            $mimeType = mime_content_type($file);
            $size = filesize($file);
        }

        if (!in_array($mimeType, $allowedTypes)) {
            return [
                'valid' => false,
                'message' => 'Chỉ chấp nhận file ảnh (JPEG, PNG, GIF, WebP)'
            ];
        }

        if ($size > $maxSize) {
            return [
                'valid' => false,
                'message' => 'File quá lớn. Tối đa 10MB'
            ];
        }

        return ['valid' => true];
    }

    private function __clone() {}
    public function __wakeup() {
        throw new Exception("Cannot unserialize singleton");
    }
}