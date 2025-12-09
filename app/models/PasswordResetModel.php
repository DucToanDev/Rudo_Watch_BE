<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/function.php';

class PasswordResetModel
{
    private $conn;
    private $table_name = 'password_resets';

    public function __construct()
    {
        try {
            $database = new Database();
            $this->conn = $database->getConnection();
            if (!$this->conn) {
                throw new Exception('Database connection is null');
            }
        } catch (Exception $e) {
            error_log('PasswordResetModel constructor error: ' . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Tạo token reset password mới
     */
    public function createToken($email, $code = null)
    {
        try {

            // Xóa các token cũ của email này
            $this->deleteByEmail($email);

            // Tạo token mới
            $token = bin2hex(random_bytes(32));
            $expiresAt = date('Y-m-d H:i:s', time() + 600); // 10 phút

            $data = [
                'email' => $email,
                'token' => $token,
                'code' => $code,
                'expires_at' => $expiresAt
            ];

            $id = insert($this->conn, $this->table_name, $data);
            
            if ($id) {
                return [
                    'success' => true,
                    'token' => $token,
                    'code' => $code,
                    'expires_at' => $expiresAt
                ];
            }

            return ['success' => false, 'message' => 'Không thể tạo token - insert() trả về false'];
        } catch (PDOException $e) {
            return ['success' => false, 'message' => 'Lỗi database: ' . $e->getMessage()];
        } catch (Exception $e) {
            return ['success' => false, 'message' => 'Lỗi: ' . $e->getMessage()];
        }
    }

   
    /**
     * Tìm token theo email và code
     */
    public function findByEmailAndCode($email, $code)
    {
        try {
            $query = "SELECT * FROM {$this->table_name} 
                     WHERE email = :email 
                     AND code = :code 
                     AND expires_at > NOW() 
                     AND used_at IS NULL 
                     ORDER BY created_at DESC 
                     LIMIT 1";
            
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':email', $email);
            $stmt->bindParam(':code', $code);
            $stmt->execute();
            
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return $result ?: null;
        } catch (PDOException $e) {
            return null;
        }
    }

    /**
     * Tìm token theo token string
     */
    public function findByToken($token)
    {
        try {
            $query = "SELECT * FROM {$this->table_name} 
                     WHERE token = :token 
                     AND expires_at > NOW() 
                     AND used_at IS NULL 
                     LIMIT 1";
            
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':token', $token);
            $stmt->execute();
            
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return $result ?: null;
        } catch (PDOException $e) {
            return null;
        }
    }

    
    public function markAsUsed($id)
    {
        try {
            $query = "UPDATE {$this->table_name} 
                     SET used_at = NOW() 
                     WHERE id = :id";
            
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            return $stmt->execute();
        } catch (PDOException $e) {
            return false;
        }
    }

    public function deleteByEmail($email)
    {
        try {
            $query = "DELETE FROM {$this->table_name} WHERE email = :email";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':email', $email);
            return $stmt->execute();
        } catch (PDOException $e) {
            return false;
        }
    }


    public function deleteExpired()
    {
        try {
            $query = "DELETE FROM {$this->table_name} WHERE expires_at < NOW()";
            $stmt = $this->conn->prepare($query);
            return $stmt->execute();
        } catch (PDOException $e) {
            return false;
        }
    }

    public function getRecentRequestCount($email, $minutes = 5)
    {
        try {
            $query = "SELECT COUNT(*) as count FROM {$this->table_name} 
                     WHERE email = :email 
                     AND created_at > DATE_SUB(NOW(), INTERVAL :minutes MINUTE)";
            
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':email', $email);
            $stmt->bindValue(':minutes', $minutes, PDO::PARAM_INT);
            $stmt->execute();
            
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return (int)($result['count'] ?? 0);
        } catch (PDOException $e) {
            return 0;
        }
    }
}

