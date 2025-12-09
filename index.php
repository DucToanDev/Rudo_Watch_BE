<?php
// Error handling cho production
error_reporting(E_ALL);
ini_set('display_errors', '0'); // Không hiển thị errors trên production
ini_set('log_errors', '1');
ini_set('error_log', __DIR__ . '/storage/logs/php-errors.log');

// Tạo thư mục logs nếu chưa có
$logDir = __DIR__ . '/storage/logs';
if (!is_dir($logDir)) {
    @mkdir($logDir, 0755, true);
}

// Set exception handler
set_exception_handler(function ($exception) {
    error_log('Uncaught exception: ' . $exception->getMessage());
    error_log('Stack trace: ' . $exception->getTraceAsString());
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode([
        'status' => 'error',
        'statusCode' => 500,
        'data' => ['error' => 'Internal server error']
    ], JSON_UNESCAPED_UNICODE);
    exit();
});

// Set error handler
set_error_handler(function ($severity, $message, $file, $line) {
    if (!(error_reporting() & $severity)) {
        return false;
    }
    error_log("PHP Error: $message in $file on line $line");
    return true;
});

require_once __DIR__ . '/config/cors.php';

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
require_once __DIR__ . '/app/core/Response.php';
require_once __DIR__ . '/app/core/Router.php';

$response = new Response();

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

$uriSegments = explode('/', $uri);

if ($uriSegments[0] !== 'api' || !isset($uriSegments[1])) {
    $response->json(['error' => 'Yêu cầu không hợp lệ'], 400);
    exit();
}

$router = new Router($uriSegments, $response);

if ($router->handleSpecialRoute()) {
    exit();
}

if ($router->handleStandardRoute()) {
    exit();
}

$response->json(['error' => 'Endpoint không tồn tại'], 404);
exit();
