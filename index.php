<?php
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

// Error handling
error_reporting(E_ALL);
ini_set('display_errors', '0');
ini_set('log_errors', '1');
ini_set('error_log', __DIR__ . '/storage/logs/php-errors.log');

// Tạo thư mục logs
$logDir = __DIR__ . '/storage/logs';
if (!is_dir($logDir)) {
    @mkdir($logDir, 0755, true);
}

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
    require_once __DIR__ . '/vendor/autoload.php';
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

// Parse URL
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

// Load core classes
require_once __DIR__ . '/app/core/Response.php';
require_once __DIR__ . '/app/core/Router.php';

// Validate URL format
if (empty($uri) || $uriSegments[0] !== 'api' || !isset($uriSegments[1])) {
    (new Response())->json(['error' => 'Yêu cầu không hợp lệ'], 400);
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