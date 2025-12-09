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

// Log request để debug
error_log('=== REQUEST DEBUG ===');
error_log('REQUEST_URI: ' . ($_SERVER['REQUEST_URI'] ?? 'N/A'));
error_log('REQUEST_METHOD: ' . ($_SERVER['REQUEST_METHOD'] ?? 'N/A'));
error_log('QUERY_STRING: ' . ($_SERVER['QUERY_STRING'] ?? 'N/A'));
error_log('GET url param: ' . (isset($_GET['url']) ? $_GET['url'] : 'N/A'));

$uri = isset($_GET['url']) ? trim($_GET['url'], '/') : '';

if (empty($uri) && isset($_SERVER['REQUEST_URI'])) {
    $requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    error_log('Parsed REQUEST_URI: ' . $requestUri);

    $requestUri = strtok($requestUri, '?');

    // Remove common prefixes
    $requestUri = preg_replace('#^/backend/#', '/', $requestUri);
    $requestUri = preg_replace('#^/backend$#', '/', $requestUri);
    $requestUri = preg_replace('#/index\.php$#', '', $requestUri);
    $requestUri = preg_replace('#^/index\.php#', '', $requestUri);

    $uri = trim($requestUri, '/');
    error_log('Final URI: ' . $uri);
}

$uriSegments = explode('/', $uri);
error_log('URI Segments: ' . json_encode($uriSegments));

if (empty($uri) || $uriSegments[0] !== 'api' || !isset($uriSegments[1])) {
    error_log('Invalid URI structure - returning 400');
    $response->json([
        'error' => 'Yêu cầu không hợp lệ',
        'debug' => [
            'uri' => $uri,
            'segments' => $uriSegments,
            'request_uri' => $_SERVER['REQUEST_URI'] ?? 'N/A'
        ]
    ], 400);
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
