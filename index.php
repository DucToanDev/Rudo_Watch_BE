<?php
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
