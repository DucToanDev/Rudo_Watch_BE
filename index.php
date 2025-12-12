<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');
ini_set('log_errors', '1');

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

function setCorsHeaders() {
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '*';
    header('Access-Control-Allow-Origin: ' . $origin);
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept, Origin');
    header('Access-Control-Max-Age: 86400');
}

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    setCorsHeaders();
    http_response_code(200);
    exit();
}

setCorsHeaders();

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

try {
    require_once __DIR__ . '/app/core/Response.php';
    require_once __DIR__ . '/app/core/Router.php';
} catch (Exception $e) {
    header('Content-Type: application/json');
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'statusCode' => 500,
        'data' => ['error' => 'Failed to load core classes']
    ], JSON_UNESCAPED_UNICODE);
    exit();
}

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

    if ($router->handleSpecialRoute()) {
        exit();
    }

    if ($router->handleStandardRoute()) {
        exit();
    }

    $response->json(['error' => 'Endpoint không tồn tại'], 404);
    exit();
} catch (Throwable $e) {
    header('Content-Type: application/json');
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'statusCode' => 500,
        'data' => ['error' => 'Internal server error']
    ], JSON_UNESCAPED_UNICODE);
    exit();
}