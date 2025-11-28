<?php

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

require_once __DIR__ . '/config/cors.php';
require_once __DIR__ . '/app/core/Response.php';
require_once __DIR__ . '/app/core/Router.php';

//hello war gbgfbfbfbg
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

// error_log("Parsed URI: " . $uri);
// error_log("URI Segments: " . print_r(explode('/', $uri), true));

$uriSegments = explode('/', $uri);

// Handle Swagger UI
if ($uriSegments[0] === 'swagger' || $uriSegments[0] === 'api-docs') {
    $swaggerPath = __DIR__ . '/swagger/index.html';
    if (file_exists($swaggerPath)) {
        readfile($swaggerPath);
        exit();
    }
}

// Handle Swagger JSON
if ($uriSegments[0] === 'swagger.json' || ($uriSegments[0] === 'swagger' && isset($uriSegments[1]) && $uriSegments[1] === 'swagger.json')) {
    $swaggerJsonPath = __DIR__ . '/swagger/swagger.json';
    if (file_exists($swaggerJsonPath)) {
        header('Content-Type: application/json');
        readfile($swaggerJsonPath);
        exit();
    }
}

// Validate API format
if ($uriSegments[0] !== 'api' || !isset($uriSegments[1])) {
    $response->json(['error' => 'Yêu cầu không hợp lệ'], 400);
    exit();
}

// Initialize Router
$router = new Router($uriSegments, $response);

// Try special routes first (register, login, home, user)
if ($router->handleSpecialRoute()) {
    exit();
}

// Handle standard CRUD routes
if ($router->handleStandardRoute()) {
    exit();
}

// No route matched
$response->json(['error' => 'Endpoint không tồn tại'], 404);
exit();