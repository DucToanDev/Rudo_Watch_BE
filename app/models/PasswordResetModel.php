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
            $this->conn = Database::getInstance()->getConnection();
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
            
            // Sử dụng SQL để tính expires_at trực tiếp, tránh vấn đề timezone
            // DATE_ADD(NOW(), INTERVAL 10 MINUTE) đảm bảo thời gian tính từ database
            $query = "INSERT INTO {$this->table_name} 
                     (email, token, code, expires_at, created_at) 
                     VALUES 
                     (:email, :token, :code, DATE_ADD(NOW(), INTERVAL 10 MINUTE), NOW())";
            
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':email', $email);
            $stmt->bindParam(':token', $token);
            $stmt->bindParam(':code', $code);
            $stmt->execute();
            
            $id = $this->conn->lastInsertId();
            
            if ($id) {
                // Lấy expires_at vừa tạo để trả về
                $expiresAtQuery = "SELECT expires_at FROM {$this->table_name} WHERE id = :id";
                $expiresStmt = $this->conn->prepare($expiresAtQuery);
                $expiresStmt->bindParam(':id', $id, PDO::PARAM_INT);
                $expiresStmt->execute();
                $expiresResult = $expiresStmt->fetch(PDO::FETCH_ASSOC);
                $expiresAt = $expiresResult['expires_at'] ?? null;
                
                return [
                    'success' => true,
                    'token' => $token,
                    'code' => $code,
                    'expires_at' => $expiresAt
                ];
            }

            return ['success' => false, 'message' => 'Không thể tạo token'];
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
            // Kiểm tra với điều kiện expires_at > NOW() để đảm bảo chưa hết hạn
            // Sử dụng SQL để so sánh thời gian, đảm bảo cùng timezone
            $query = "SELECT *, 
                     TIMESTAMPDIFF(SECOND, NOW(), expires_at) as seconds_remaining
                     FROM {$this->table_name} 
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
            
            // Nếu có kết quả, SQL đã kiểm tra expires_at > NOW() nên hợp lệ
            // Kiểm tra thêm seconds_remaining để đảm bảo
            if ($result) {
                $secondsRemaining = isset($result['seconds_remaining']) ? (int)$result['seconds_remaining'] : null;
                
                // Nếu có seconds_remaining, kiểm tra phải > 0
                if ($secondsRemaining !== null) {
                    if ($secondsRemaining > 0) {
                        return $result;
                    } else {
                        // Đã hết hạn
                        return null;
                    }
                }
                
                // Nếu không có seconds_remaining nhưng có kết quả, vẫn trả về
                // Vì SQL đã kiểm tra expires_at > NOW()
                return $result;
            }
            
            return null;
        } catch (PDOException $e) {
            error_log('PasswordResetModel::findByEmailAndCode error: ' . $e->getMessage());
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