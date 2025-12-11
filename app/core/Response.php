<?php

class Response
{

    public function json($data, $statusCode = 200)
    {
        if (ob_get_level()) {
            ob_clean();
        }
        
        // Set CORS headers
        $origin = $_SERVER['HTTP_ORIGIN'] ?? '*';
        header('Access-Control-Allow-Origin: ' . $origin);
        header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept, Origin');
        header('Access-Control-Max-Age: 86400');
        
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