<?php

class Database {
    private static $instance = null;
    private $conn;

    private function __construct() {
        try {
            $host = getenv('DB_HOST') ?: ($_ENV['DB_HOST'] ?? null);
            $port = getenv('DB_PORT') ?: ($_ENV['DB_PORT'] ?? '3306');
            $database = getenv('DB_DATABASE') ?: ($_ENV['DB_DATABASE'] ?? null);
            $username = getenv('DB_USERNAME') ?: ($_ENV['DB_USERNAME'] ?? null);
            $password = getenv('DB_PASSWORD') ?: ($_ENV['DB_PASSWORD'] ?? null);

            if (empty($host) || empty($database) || empty($username)) {
                throw new PDOException('Thiếu cấu hình cơ sở dữ liệu!');
            }

            $dsn = "mysql:host={$host};port={$port};dbname={$database};charset=utf8mb4";
            $this->conn = new PDO($dsn, $username, $password, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
                PDO::ATTR_TIMEOUT => 5,
                PDO::ATTR_PERSISTENT => false,
                PDO::ATTR_EMULATE_PREPARES => false
            ]);
        } catch (PDOException $e) {
            error_log("Lỗi kết nối cơ sở dữ liệu: " . $e->getMessage());
            throw $e;
        }
    }
    
    // sinh ra đúng 1 object khi chạy 
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getConnection() {
        return $this->conn;
    }

    public function disconnect() {
        $this->conn = null;
    }

    private function __clone() {}
    public function __wakeup() {
        throw new Exception("Cannot unserialize singleton");
    }
}