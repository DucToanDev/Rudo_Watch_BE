<?php
// Bật error reporting ngay từ đầu
error_reporting(E_ALL);
ini_set('display_errors', '0');
ini_set('log_errors', '1');

// Tạo thư mục logs sớm
$logDir = __DIR__ . '/storage/logs';
if (!is_dir($logDir)) {
    @mkdir($logDir, 0755, true);
}
ini_set('error_log', $logDir . '/php-errors.log');

// Register shutdown function để catch fatal errors
register_shutdown_function(function() {
    $error = error_get_last();
    if ($error !== NULL && in_array($error['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR])) {
        header('Content-Type: application/json');
        http_response_code(500);
        echo json_encode([
            'status' => 'error',
            'statusCode' => 500,
            'data' => [
                'error' => 'Fatal error occurred',
                'message' => $error['message'],
                'file' => $error['file'],
                'line' => $error['line']
            ]
        ], JSON_UNESCAPED_UNICODE);
    }
});

// Parse URL sớm để check health check
$uri = isset($_GET['url']) ? trim($_GET['url'], '/') : '';

if (empty($uri) && isset($_SERVER['REQUEST_URI'])) {
    $requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    $requestUri = strtok($requestUri, '?');
    $requestUri = preg_replace('#^/backend/#', '/', $requestUri);
    $requestUri = preg_replace('#^/backend$#', '/', $requestUri);
    $requestUri = preg_replace('#/index\.php$#', '', $requestUri);
    $requestUri = preg_replace('#^/index\.php#', '', $requestUri);
    $uri = trim($requestUri, '/');
}

// Handle health check SỚM - trước khi load bất kỳ thứ gì
if (empty($uri) || $uri === 'health' || $uri === 'status' || $uri === 'api/health') {
    header('Content-Type: application/json');
    http_response_code(200);
    echo json_encode([
        'status' => 'success',
        'statusCode' => 200,
        'data' => [
            'message' => 'API is running',
            'timestamp' => date('Y-m-d H:i:s'),
            'php_version' => PHP_VERSION,
            'server' => $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown'
        ]
    ], JSON_UNESCAPED_UNICODE);
    exit();
}

// CORS helper function
function setCorsHeaders() {
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '*';
    header('Access-Control-Allow-Origin: ' . $origin);
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept, Origin');
    header('Access-Control-Max-Age: 86400');
}

// Xử lý OPTIONS preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    setCorsHeaders();
    http_response_code(200);
    exit();
}

setCorsHeaders();

// Exception handler
set_exception_handler(function ($exception) {
    setCorsHeaders();
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode([
        'status' => 'error',
        'statusCode' => 500,
        'data' => ['error' => 'Internal server error']
    ], JSON_UNESCAPED_UNICODE);
    exit();
});

// Load autoloader
if (!class_exists('Dotenv\Dotenv')) {
    $autoloadPath = __DIR__ . '/vendor/autoload.php';
    if (file_exists($autoloadPath)) {
        require_once $autoloadPath;
    }
}

// Load .env
if (file_exists(__DIR__ . '/.env')) {
    try {
        $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
        $dotenv->load();
    } catch (Exception $e) {
        // Ignore .env load errors
    }
}

$uriSegments = explode('/', $uri);

// Load core classes với error handling
try {
    if (!file_exists(__DIR__ . '/app/core/Response.php')) {
        throw new Exception('Response.php not found');
    }
    require_once __DIR__ . '/app/core/Response.php';
    
    if (!file_exists(__DIR__ . '/app/core/Router.php')) {
        throw new Exception('Router.php not found');
    }
    require_once __DIR__ . '/app/core/Router.php';
} catch (Exception $e) {
    header('Content-Type: application/json');
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'statusCode' => 500,
        'data' => ['error' => 'Failed to load core classes: ' . $e->getMessage()]
    ], JSON_UNESCAPED_UNICODE);
    exit();
}

// Validate URL format - phải bắt đầu bằng api
if (!isset($uriSegments[0]) || $uriSegments[0] !== 'api' || !isset($uriSegments[1])) {
    try {
        (new Response())->json(['error' => 'Yêu cầu không hợp lệ'], 400);
    } catch (Exception $e) {
        header('Content-Type: application/json');
        http_response_code(400);
        echo json_encode(['error' => 'Yêu cầu không hợp lệ'], JSON_UNESCAPED_UNICODE);
    }
    exit();
}

// Xử lý Authorization header
if (isset($_SERVER['REDIRECT_HTTP_AUTHORIZATION']) && !isset($_SERVER['HTTP_AUTHORIZATION'])) {
    $_SERVER['HTTP_AUTHORIZATION'] = $_SERVER['REDIRECT_HTTP_AUTHORIZATION'];
}

if (!isset($_SERVER['HTTP_AUTHORIZATION']) && function_exists('getallheaders')) {
    $headers = getallheaders();
    if (isset($headers['Authorization'])) {
        $_SERVER['HTTP_AUTHORIZATION'] = $headers['Authorization'];
    } elseif (isset($headers['authorization'])) {
        $_SERVER['HTTP_AUTHORIZATION'] = $headers['authorization'];
    }
}

try {
    $response = new Response();
    $router = new Router($uriSegments, $response);

    // Route request
    if ($router->handleSpecialRoute()) {
        exit();
    }

    if ($router->handleStandardRoute()) {
        exit();
    }

    $response->json(['error' => 'Endpoint không tồn tại'], 404);
    exit();
} catch (Throwable $e) {
    // Catch any unhandled errors
    error_log('Unhandled error: ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine());
    
    header('Content-Type: application/json');
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'statusCode' => 500,
        'data' => ['error' => 'Internal server error: ' . $e->getMessage()]
    ], JSON_UNESCAPED_UNICODE);
    exit();
}