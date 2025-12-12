<?php
// Router script for PHP built-in server
// This ensures all requests go through index.php

$uri = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));

// Serve static files if they exist
if ($uri !== '/' && file_exists(__DIR__ . $uri)) {
    return false;
}

// Route everything else to index.php
$_GET['url'] = ltrim($uri, '/');
require __DIR__ . '/index.php';

