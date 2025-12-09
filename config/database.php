<?php require_once __DIR__ . '/../vendor/autoload.php';

// Load environment variables - không fail nếu không có file .env (Railway dùng env vars trực tiếp)
try {
    if (file_exists(__DIR__ . '/../.env')) {
        $dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
        $dotenv->load();
    } else {
        // Trên Railway, env vars được set trực tiếp, không cần file .env
        error_log('No .env file found, using system environment variables');
    }
} catch (Exception $e) {
    // Không fail nếu không load được .env, có thể đang dùng system env vars
    error_log('Dotenv load warning: ' . $e->getMessage());
}

class Database {
    private $conn;

    public function __construct() {
        try {
            // Sử dụng getenv() với fallback cho Railway
            $host = getenv('DB_HOST') ?: ($_ENV['DB_HOST'] ?? null);
            $port = getenv('DB_PORT') ?: ($_ENV['DB_PORT'] ?? '3306');
            $database = getenv('DB_DATABASE') ?: ($_ENV['DB_DATABASE'] ?? null);
            $username = getenv('DB_USERNAME') ?: ($_ENV['DB_USERNAME'] ?? null);
            $password = getenv('DB_PASSWORD') ?: ($_ENV['DB_PASSWORD'] ?? null);

            if (empty($host) || empty($database) || empty($username)) {
                $error = 'Database configuration missing. Please check DB_HOST, DB_DATABASE, DB_USERNAME environment variables.';
                error_log($error);
                throw new PDOException($error);
            }

            $dsn = "mysql:host=" . $host . ";port=" . $port . ";dbname=" . $database . ";charset=utf8mb4";
            $this->conn = new PDO($dsn, $username, $password, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
                PDO::ATTR_TIMEOUT => 5
            ]);
        } catch (PDOException $e) {
            $error = "Database connection failed: " . $e->getMessage();
            error_log($error);
            // Không echo ra, để tránh break JSON response
            throw new PDOException($error);
        }
    }

    public function getConnection() {
        return $this->conn;
    }

    public function disconnect() {
        $this->conn = null;
    }
}