<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');
ini_set('log_errors', '1');

$uri = '';

// Strategy 1: Thử lấy từ query parameter (nếu có .htaccess rewrite)
if (isset($_GET['url']) && !empty($_GET['url'])) {
    $uri = trim($_GET['url'], '/');
}

// Strategy 2: Parse từ REQUEST_URI
if (empty($uri) && isset($_SERVER['REQUEST_URI'])) {
    $requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    if ($requestUri === false || empty($requestUri)) {
        $requestUri = $_SERVER['REQUEST_URI'];
    }
    
    // Loại bỏ query string nếu có
    $requestUri = strtok($requestUri, '?');
    
    // Loại bỏ base path nếu có
    $requestUri = preg_replace('#^/backend/#', '/', $requestUri);
    $requestUri = preg_replace('#^/backend$#', '/', $requestUri);
    
    // Loại bỏ index.php nếu có
    $requestUri = preg_replace('#/index\.php$#', '', $requestUri);
    $requestUri = preg_replace('#^/index\.php#', '', $requestUri);
    $requestUri = preg_replace('#^/index\.php/#', '/', $requestUri);
    
    // Nếu REQUEST_URI trỏ đến index.php, lấy phần sau
    if (strpos($requestUri, '/index.php') !== false) {
        $requestUri = substr($requestUri, strpos($requestUri, '/index.php') + strlen('/index.php'));
    }
    
    // Loại bỏ leading/trailing slashes
    $uri = trim($requestUri, '/');
}

// Strategy 3: Thử PATH_INFO
if (empty($uri) && isset($_SERVER['PATH_INFO']) && !empty($_SERVER['PATH_INFO'])) {
    $uri = trim($_SERVER['PATH_INFO'], '/');
}

// Strategy 4: Tính từ SCRIPT_NAME và REQUEST_URI
if (empty($uri) && isset($_SERVER['SCRIPT_NAME']) && isset($_SERVER['REQUEST_URI'])) {
    $scriptName = $_SERVER['SCRIPT_NAME'];
    $requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    
    if ($requestUri !== false && $requestUri !== $scriptName) {
        // Nếu REQUEST_URI chứa SCRIPT_NAME, lấy phần còn lại
        if (strpos($requestUri, $scriptName) === 0) {
            $uri = trim(substr($requestUri, strlen($scriptName)), '/');
        }
        // Nếu không, thử lấy relative path
        elseif (dirname($scriptName) !== '/' && strpos($requestUri, dirname($scriptName)) === 0) {
            $basePath = dirname($scriptName);
            $uri = trim(substr($requestUri, strlen($basePath)), '/');
        }
    }
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

// Debug endpoint (có thể xóa sau khi debug xong)
if ($uri === 'debug' || $uri === 'api/debug') {
    header('Content-Type: application/json');
    http_response_code(200);
    echo json_encode([
        'status' => 'success',
        'data' => [
            'parsed_uri' => $uri,
            'uri_segments' => explode('/', $uri),
            'request_uri' => $_SERVER['REQUEST_URI'] ?? 'N/A',
            'query_url' => $_GET['url'] ?? 'N/A',
            'path_info' => $_SERVER['PATH_INFO'] ?? 'N/A',
            'script_name' => $_SERVER['SCRIPT_NAME'] ?? 'N/A',
            'method' => $_SERVER['REQUEST_METHOD'] ?? 'N/A'
        ]
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
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

    // Debug info nếu endpoint không tồn tại
    $debugInfo = [
        'error' => 'Endpoint không tồn tại',
        'parsed_uri' => $uri,
        'uri_segments' => $uriSegments,
        'method' => $_SERVER['REQUEST_METHOD'] ?? 'N/A',
        'request_uri' => $_SERVER['REQUEST_URI'] ?? 'N/A',
        'router' => $router->getDebugInfo()
    ];
    
    $response->json($debugInfo, 404);
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