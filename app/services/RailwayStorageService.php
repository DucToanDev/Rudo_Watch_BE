<?php

require_once __DIR__ . '/../../vendor/autoload.php';

use Aws\S3\S3Client;
use Aws\Exception\AwsException;

class RailwayStorageService
{
    private $s3Client;
    private $bucket;
    private $region;
    private $endpoint;
    private $baseUrl;

    public function __construct()
    {
        // Lấy cấu hình từ environment
        // Hỗ trợ cả AWS_* (Railway default) và RAILWAY_S3_* (custom)
        // Ưu tiên đọc từ getenv() trước (cho Railway), sau đó mới $_ENV (cho local .env)
        $this->endpoint = getenv('RAILWAY_S3_ENDPOINT') 
            ?: getenv('AWS_ENDPOINT_URL')
            ?: ($_ENV['RAILWAY_S3_ENDPOINT'] ?? $_ENV['AWS_ENDPOINT_URL'] ?? 'https://storage.railway.app');
            
        $this->region = getenv('RAILWAY_S3_REGION') 
            ?: getenv('AWS_DEFAULT_REGION')
            ?: ($_ENV['RAILWAY_S3_REGION'] ?? $_ENV['AWS_DEFAULT_REGION'] ?? 'us-east-1');
            
        $this->bucket = getenv('RAILWAY_S3_BUCKET') 
            ?: getenv('AWS_S3_BUCKET_NAME')
            ?: ($_ENV['RAILWAY_S3_BUCKET'] ?? $_ENV['AWS_S3_BUCKET_NAME'] ?? '');
            
        $accessKeyId = getenv('RAILWAY_S3_ACCESS_KEY') 
            ?: getenv('AWS_ACCESS_KEY_ID')
            ?: ($_ENV['RAILWAY_S3_ACCESS_KEY'] ?? $_ENV['AWS_ACCESS_KEY_ID'] ?? '');
            
        $secretAccessKey = getenv('RAILWAY_S3_SECRET_KEY') 
            ?: getenv('AWS_SECRET_ACCESS_KEY')
            ?: ($_ENV['RAILWAY_S3_SECRET_KEY'] ?? $_ENV['AWS_SECRET_ACCESS_KEY'] ?? '');
            
        $this->baseUrl = getenv('RAILWAY_S3_BASE_URL') 
            ?: getenv('AWS_ENDPOINT_URL')
            ?: ($_ENV['RAILWAY_S3_BASE_URL'] ?? $_ENV['AWS_ENDPOINT_URL'] ?? $this->endpoint);

        // Trim để loại bỏ khoảng trắng thừa
        $this->endpoint = trim($this->endpoint);
        $this->region = trim($this->region);
        $this->bucket = trim($this->bucket);
        $accessKeyId = trim($accessKeyId);
        $secretAccessKey = trim($secretAccessKey);
        $this->baseUrl = trim($this->baseUrl);

        if (empty($this->bucket) || empty($accessKeyId) || empty($secretAccessKey)) {
            // Debug info để kiểm tra
            $debug = [
                'bucket' => !empty($this->bucket) ? 'SET' : 'EMPTY',
                'access_key' => !empty($accessKeyId) ? 'SET (length: ' . strlen($accessKeyId) . ')' : 'EMPTY',
                'secret_key' => !empty($secretAccessKey) ? 'SET (length: ' . strlen($secretAccessKey) . ')' : 'EMPTY',
                'env_vars' => [
                    'RAILWAY_S3_BUCKET' => !empty($_ENV['RAILWAY_S3_BUCKET']),
                    'AWS_S3_BUCKET_NAME' => !empty($_ENV['AWS_S3_BUCKET_NAME']),
                    'RAILWAY_S3_ACCESS_KEY' => !empty($_ENV['RAILWAY_S3_ACCESS_KEY']),
                    'AWS_ACCESS_KEY_ID' => !empty($_ENV['AWS_ACCESS_KEY_ID']),
                    'RAILWAY_S3_SECRET_KEY' => !empty($_ENV['RAILWAY_S3_SECRET_KEY']),
                    'AWS_SECRET_ACCESS_KEY' => !empty($_ENV['AWS_SECRET_ACCESS_KEY']),
                ]
            ];
            throw new Exception('Thiếu cấu hình Railway S3. Debug: ' . json_encode($debug, JSON_PRETTY_PRINT));
        }

        // Khởi tạo S3 Client với Railway endpoint
        // Railway S3 cần cấu hình đặc biệt cho S3-compatible storage
        // Đảm bảo region là us-east-1, không dùng 'auto'
        $region = ($this->region === 'auto' || empty($this->region) || $this->region === '') ? 'us-east-1' : $this->region;
        
        // Validate credentials
        if (empty($accessKeyId) || empty($secretAccessKey)) {
            throw new Exception('Access Key hoặc Secret Key không được để trống');
        }
        
        $config = [
            'version' => 'latest',
            'region' => $region,
            'endpoint' => $this->endpoint,
            'use_path_style_endpoint' => true, // Bắt buộc cho S3-compatible storage
            'credentials' => [
                'key' => $accessKeyId,
                'secret' => $secretAccessKey,
            ],
            'signature_version' => 'v4',
        ];

        // Chỉ tắt SSL verify trong môi trường dev (nếu cần)
        if (isset($_ENV['APP_ENV']) && $_ENV['APP_ENV'] === 'development') {
            $config['http'] = ['verify' => false];
        }

        $this->s3Client = new S3Client($config);
        
        // Test kết nối và quyền truy cập (chỉ log, không throw)
        try {
            $this->s3Client->headBucket(['Bucket' => $this->bucket]);
        } catch (AwsException $e) {
            // Log warning nhưng không throw để có thể fallback
            error_log('Railway S3 connection warning: ' . $e->getMessage());
        }
    }

    /**
     * Upload file lên Railway S3
     * @param string $filePath Đường dẫn file local hoặc file upload
     * @param string $folder Thư mục trên S3 (ví dụ: 'products', 'users', 'uploads')
     * @param string $fileName Tên file (nếu null sẽ tự động generate)
     * @return array ['success' => bool, 'url' => string, 'key' => string]
     */
    public function uploadFile($filePath, $folder = 'uploads', $fileName = null)
    {
        try {
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

                $fileContent = file_get_contents($tmpFile);
                $mimeType = $filePath['type'] ?? mime_content_type($tmpFile);
                
                if (!$fileName) {
                    $extension = pathinfo($originalName, PATHINFO_EXTENSION);
                    $fileName = $this->generateFileName($extension);
                }
            } else {
                // File path từ local
                if (!file_exists($filePath)) {
                    return [
                        'success' => false,
                        'message' => 'File không tồn tại'
                    ];
                }

                $fileContent = file_get_contents($filePath);
                $mimeType = mime_content_type($filePath);
                
                if (!$fileName) {
                    $extension = pathinfo($filePath, PATHINFO_EXTENSION);
                    $fileName = $this->generateFileName($extension);
                }
            }

            // Tạo key (đường dẫn trên S3)
            $key = trim($folder, '/') . '/' . $fileName;

            // Upload lên S3
            $putObjectParams = [
                'Bucket' => $this->bucket,
                'Key' => $key,
                'Body' => $fileContent,
                'ContentType' => $mimeType,
            ];

            // Không dùng ACL (Railway có thể không hỗ trợ)
            $result = $this->s3Client->putObject($putObjectParams);

            // Tạo URL công khai hoặc presigned URL
            // Railway S3 thường không public mặc định, nên dùng presigned URL
            // Presigned URL có thời hạn 1 giờ (3600 giây)
            $url = $this->getPresignedUrl($key, 3600);
            
            // Nếu muốn dùng public URL (cần cấu hình bucket public trên Railway):
            // $url = $this->getPublicUrl($key);

            return [
                'success' => true,
                'url' => $url,
                'key' => $key,
                'bucket' => $this->bucket
            ];
        } catch (AwsException $e) {
            $errorMessage = $e->getMessage();
            
            // Thêm thông tin debug chi tiết để kiểm tra
            $debugInfo = [
                'error_code' => $e->getAwsErrorCode(),
                'error_message' => $errorMessage,
                'config' => [
                    'endpoint' => $this->endpoint,
                    'bucket' => $this->bucket,
                    'region' => $this->region,
                    'access_key_length' => strlen($this->s3Client->getCredentials()->wait()->getAccessKeyId()),
                    'secret_key_length' => strlen($this->s3Client->getCredentials()->wait()->getSecretKey()),
                ],
                'env_check' => [
                    'AWS_ENDPOINT_URL' => !empty(getenv('AWS_ENDPOINT_URL')),
                    'AWS_S3_BUCKET_NAME' => !empty(getenv('AWS_S3_BUCKET_NAME')),
                    'AWS_ACCESS_KEY_ID' => !empty(getenv('AWS_ACCESS_KEY_ID')),
                    'AWS_SECRET_ACCESS_KEY' => !empty(getenv('AWS_SECRET_ACCESS_KEY')),
                    'AWS_DEFAULT_REGION' => !empty(getenv('AWS_DEFAULT_REGION')),
                    'RAILWAY_S3_ENDPOINT' => !empty(getenv('RAILWAY_S3_ENDPOINT')),
                    'RAILWAY_S3_BUCKET' => !empty(getenv('RAILWAY_S3_BUCKET')),
                ]
            ];
            
            return [
                'success' => false,
                'message' => 'Lỗi upload S3: ' . $errorMessage,
                'debug' => $debugInfo // Xem debug để kiểm tra cấu hình
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
    public function uploadFiles($files, $folder = 'uploads')
    {
        $results = [];
        
        foreach ($files as $file) {
            $result = $this->uploadFile($file, $folder);
            $results[] = $result;
        }

        return $results;
    }

    /**
     * Xóa file từ S3
     */
    public function deleteFile($key)
    {
        try {
            $result = $this->s3Client->deleteObject([
                'Bucket' => $this->bucket,
                'Key' => $key,
            ]);

            return [
                'success' => true,
                'message' => 'Xóa file thành công'
            ];
        } catch (AwsException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi xóa file: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Kiểm tra file có tồn tại không
     */
    public function fileExists($key)
    {
        try {
            return $this->s3Client->doesObjectExist($this->bucket, $key);
        } catch (Exception $e) {
            return false;
        }
    }

    /**
     * Lấy URL công khai của file
     */
    public function getPublicUrl($key)
    {
        // Railway S3 URL format: https://storage.railway.app/{bucket}/{key}
        return rtrim($this->baseUrl, '/') . '/' . $this->bucket . '/' . ltrim($key, '/');
    }

    /**
     * Tạo presigned URL (có thời hạn, không cần public access)
     * @param string $key
     * @param int $expiration Thời gian hết hạn (giây), mặc định 1 giờ
     * @return string
     */
    public function getPresignedUrl($key, $expiration = 3600)
    {
        try {
            $cmd = $this->s3Client->getCommand('GetObject', [
                'Bucket' => $this->bucket,
                'Key' => $key
            ]);

            $request = $this->s3Client->createPresignedRequest($cmd, '+' . $expiration . ' seconds');
            return (string) $request->getUri();
        } catch (Exception $e) {
            // Fallback về public URL nếu lỗi
            return $this->getPublicUrl($key);
        }
    }

    /**
     * Tạo tên file unique
     */
    private function generateFileName($extension)
    {
        $timestamp = time();
        $random = bin2hex(random_bytes(8));
        return $timestamp . '_' . $random . '.' . $extension;
    }

    /**
     * Validate file type
     */
    public function validateImage($file)
    {
        $allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
        $maxSize = 5 * 1024 * 1024; // 5MB

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
                'message' => 'File quá lớn. Tối đa 5MB'
            ];
        }

        return ['valid' => true];
    }
}

