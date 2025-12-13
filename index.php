<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');
ini_set('log_errors', '1');

// 1. ĐỊNH NGHĨA HÀM CORS SỚM (Để dùng được ở mọi nơi)
function setCorsHeaders() {
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '*';
    header('Access-Control-Allow-Origin: ' . $origin);
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept, Origin');
    header('Access-Control-Max-Age: 86400');
    header('Access-Control-Allow-Credentials: true');
}

// Xử lý Preflight Request (OPTIONS) ngay lập tức
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    setCorsHeaders();
    http_response_code(200);
    exit();
}

// Bật CORS cho tất cả request
setCorsHeaders();

$uri = '';

// -----------------------------------------------------------
// URI PARSING STRATEGIES 
// -----------------------------------------------------------

// Thử lấy từ query parameter 
if (isset($_GET['url']) && !empty($_GET['url'])) {
    $uri = trim($_GET['url'], '/');
}

// Parse từ REQUEST_URI
if (empty($uri) && isset($_SERVER['REQUEST_URI'])) {
    $requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    if ($requestUri === false || empty($requestUri)) {
        $requestUri = $_SERVER['REQUEST_URI'];
    }
    
    $requestUri = strtok($requestUri, '?');
    
    // Loại bỏ base path
    $requestUri = preg_replace('#^/backend/#', '/', $requestUri);
    $requestUri = preg_replace('#^/backend$#', '/', $requestUri);
    
    // Loại bỏ index.php
    $requestUri = preg_replace('#/index\.php$#', '', $requestUri);
    $requestUri = preg_replace('#^/index\.php#', '', $requestUri);
    $requestUri = preg_replace('#^/index\.php/#', '/', $requestUri);
    
    if (strpos($requestUri, '/index.php') !== false) {
        $requestUri = substr($requestUri, strpos($requestUri, '/index.php') + strlen('/index.php'));
    }
    
    $uri = trim($requestUri, '/');
}

// Thử PATH_INFO
if (empty($uri) && isset($_SERVER['PATH_INFO']) && !empty($_SERVER['PATH_INFO'])) {
    $uri = trim($_SERVER['PATH_INFO'], '/');
}

// Strategy 4: Tính từ SCRIPT_NAME và REQUEST_URI
if (empty($uri) && isset($_SERVER['SCRIPT_NAME']) && isset($_SERVER['REQUEST_URI'])) {
    $scriptName = $_SERVER['SCRIPT_NAME'];
    $requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    
    if ($requestUri !== false && $requestUri !== $scriptName) {
        if (strpos($requestUri, $scriptName) === 0) {
            $uri = trim(substr($requestUri, strlen($scriptName)), '/');
        }
        elseif (dirname($scriptName) !== '/' && strpos($requestUri, dirname($scriptName)) === 0) {
            $basePath = dirname($scriptName);
            $uri = trim(substr($requestUri, strlen($basePath)), '/');
        }
    }
}

// -----------------------------------------------------------
// SWAGGER UI
// -----------------------------------------------------------
if ($uri === 'api-docs' || $uri === 'swagger' || $uri === 'docs') {
    $swaggerHtmlPath = __DIR__ . '/swagger-ui.html';
    if (file_exists($swaggerHtmlPath)) {
        header('Content-Type: text/html; charset=UTF-8');
        readfile($swaggerHtmlPath);
        exit();
    } else {
        header('Content-Type: application/json');
        http_response_code(404);
        echo json_encode([
            'status' => 'error',
            'statusCode' => 404,
            'data' => ['error' => 'Swagger UI file not found']
        ], JSON_UNESCAPED_UNICODE);
        exit();
    }
}

// -----------------------------------------------------------
// HYBRID HEALTH CHECK / HOME PAGE 
// -----------------------------------------------------------
if (empty($uri) || $uri === 'health' || $uri === 'status' || $uri === 'api/health') {
    
    $data = [
        'project' => 'RUDO WATCH API',
        'author'  => 'Phan Duc Toan', 
        'status'  => 'success',
        'message' => 'System Operational',
        'statusCode' => 200,
        'timestamp' => date('Y-m-d H:i:s'),
        'server' => [
            'php_version' => PHP_VERSION,
            'software' => $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown'
        ]
    ];

    $accept = $_SERVER['HTTP_ACCEPT'] ?? '';
    
    if (strpos($accept, 'text/html') !== false && !isset($_SERVER['HTTP_CONTENT_TYPE'])) {
        header('Content-Type: text/html; charset=utf-8');
        ?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RUDO WATCH API Status</title>
    <style>
    :root {
        --bg: #050505;
        --primary: #00ff41;
        --secondary: #008F11;
        --text: #e0e0e0;
    }

    body {
        background-color: var(--bg);
        color: var(--text);
        font-family: 'Courier New', Courier, monospace;
        margin: 0;
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }

    .terminal {
        border: 2px solid #333;
        padding: 40px;
        border-radius: 8px;
        background: rgba(0, 20, 0, 0.9);
        box-shadow: 0 0 20px rgba(0, 255, 65, 0.1);
        max-width: 600px;
        width: 90%;
        position: relative;
    }

    .glitch {
        font-size: 2rem;
        font-weight: bold;
        text-transform: uppercase;
        position: relative;
        text-shadow: 2px 2px 0px #ff00ff, -2px -2px 0px #00ffff;
        animation: glitch 1s infinite alternate-reverse;
        margin-bottom: 10px;
    }

    .sub-text {
        color: var(--primary);
        font-size: 1.1rem;
        margin-bottom: 30px;
        letter-spacing: 1px;
    }

    .status-line {
        display: flex;
        align-items: center;
        margin-top: 20px;
        border-top: 1px solid #333;
        padding-top: 20px;
    }

    .indicator {
        width: 12px;
        height: 12px;
        background-color: var(--primary);
        border-radius: 50%;
        box-shadow: 0 0 10px var(--primary);
        animation: pulse 1.5s infinite;
        margin-right: 15px;
    }

    .meta {
        font-size: 0.8rem;
        color: #666;
        margin-top: 5px;
    }

    /* Animations */
    @keyframes pulse {
        0% {
            opacity: 1;
            transform: scale(1);
        }

        50% {
            opacity: 0.5;
            transform: scale(0.8);
        }

        100% {
            opacity: 1;
            transform: scale(1);
        }
    }

    @keyframes glitch {
        0% {
            text-shadow: 2px 2px 0px #ff00ff, -2px -2px 0px #00ffff;
        }

        25% {
            text-shadow: -2px 2px 0px #ff00ff, 2px -2px 0px #00ffff;
        }

        50% {
            text-shadow: 2px -2px 0px #ff00ff, -2px 2px 0px #00ffff;
        }

        75% {
            text-shadow: -2px -2px 0px #ff00ff, 2px 2px 0px #00ffff;
        }

        100% {
            text-shadow: 2px 2px 0px #ff00ff, -2px -2px 0px #00ffff;
        }
    }

    .typing-effect {
        overflow: hidden;
        border-right: .15em solid orange;
        white-space: nowrap;
        margin: 0;
        animation: typing 3.5s steps(40, end), blink-caret .75s step-end infinite;
    }

    @keyframes typing {
        from {
            width: 0
        }

        to {
            width: 100%
        }
    }

    @keyframes blink-caret {

        from,
        to {
            border-color: transparent
        }

        50% {
            border-color: orange;
        }
    }
    </style>
</head>

<body>
    <div class="terminal">
        <div class="glitch" data-text="<?php echo $data['project']; ?>"><?php echo $data['project']; ?></div>
        <div class="sub-text typing-effect">Dev: <?php echo $data['author']; ?></div>

        <div class="status-line">
            <div class="indicator"></div>
            <div>
                <div style="color: white; font-weight: bold;">SYSTEM ONLINE</div>
                <div class="meta">Server Time: <?php echo $data['timestamp']; ?></div>
            </div>
        </div>

        <div style="margin-top: 20px; font-size: 0.75rem; color: #444;">
            PHP v<?php echo $data['server']['php_version']; ?> | Secure Connection
        </div>
    </div>
</body>

</html>
<?php
        exit();
    }

    header('Content-Type: application/json');
    http_response_code(200);
    echo json_encode([
        'status' => 'success',
        'statusCode' => 200,
        'data' => $data
    ], JSON_UNESCAPED_UNICODE);
    exit();
}

// -----------------------------------------------------------
// MAIN APP LOGIC
// -----------------------------------------------------------

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
    }
}

// Load helper functions
require_once __DIR__ . '/config/function.php';

set_exception_handler(function ($exception) {
    setCorsHeaders();
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode([
        'status' => 'error',
        'statusCode' => 500,
        'data' => ['error' => sanitize_sql_error($exception)]
    ], JSON_UNESCAPED_UNICODE);
    exit();
});

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