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
        
        // Nếu có origin header, luôn set origin đó (browser sẽ validate)
        if ($origin) {
            header('Access-Control-Allow-Origin: ' . $origin);
            header('Access-Control-Allow-Credentials: true');
        } else {
            // Chỉ khi không có origin header mới dùng wildcard
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