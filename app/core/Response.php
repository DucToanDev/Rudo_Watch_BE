<?php

class Response
{

    public function json($data, $statusCode = 200)
    {
        if (ob_get_level()) {
            ob_clean();
        }
        
        // Set CORS headers - đồng bộ với index.php
        $origin = $_SERVER['HTTP_ORIGIN'] ?? null;
        
        // Whitelist các origins được phép
        $allowedOrigins = [
            'http://localhost:3000',
            'http://localhost:5173',
            'http://localhost:8080',
            'https://rudowatch.store',
            'https://www.rudowatch.store',
            'https://api.rudowatch.store',
            'http://rudowatch.store',
            'http://www.rudowatch.store',
            'http://api.rudowatch.store'
        ];
        
        // Nếu có origin, kiểm tra và set
        if ($origin) {
            // Kiểm tra origin có trong whitelist hoặc là localhost/127.0.0.1
            if (in_array($origin, $allowedOrigins) || 
                strpos($origin, 'localhost') !== false || 
                strpos($origin, '127.0.0.1') !== false ||
                strpos($origin, 'rudowatch.store') !== false) {
                header('Access-Control-Allow-Origin: ' . $origin);
                header('Access-Control-Allow-Credentials: true');
            } else {
                // Nếu không match, vẫn set origin đó nhưng không dùng credentials
                header('Access-Control-Allow-Origin: ' . $origin);
            }
        } else {
            // Nếu không có origin header, dùng wildcard
            header('Access-Control-Allow-Origin: *');
        }
        
        header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept, Origin');
        header('Access-Control-Max-Age: 86400');
        header('Vary: Origin');
        
        header("Content-Type: application/json");
        http_response_code($statusCode);

        echo json_encode([
            'status' => ($statusCode >= 200 && $statusCode < 300) ? 'success' : 'error',
            'statusCode' => $statusCode,
            'data' => $data
        ], JSON_UNESCAPED_UNICODE);
        exit();
    }
}