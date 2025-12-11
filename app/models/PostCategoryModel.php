<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';
require_once __DIR__ . '/../../config/function.php';

class PostCategories
{
    private $conn;
    private $table_name = 'posts_categories';
    public $response;

    public $id;
    public $name;
    public $slug;
    public $created_at;

    public function __construct()
    {
        $this->conn = Database::getInstance()->getConnection();
        $this->response = new Response();
    }

    /**
     * Lấy tất cả danh mục bài viết
     */
    public function getAll($params = [])
    {
        try {
            $query = "SELECT * FROM " . $this->table_name . " ORDER BY id DESC";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Lấy danh mục theo ID
     */
    public function getById($id)
    {
        try {
            $query = "SELECT * FROM " . $this->table_name . " WHERE id = :id LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Lấy danh mục theo slug
     */
    public function getBySlug($slug)
    {
        try {
            $query = "SELECT * FROM " . $this->table_name . " WHERE slug = :slug LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':slug', $slug);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Lấy danh mục đang active (tất cả vì không có status field)
     */
    public function getActive()
    {
        try {
            $query = "SELECT * FROM " . $this->table_name . " ORDER BY name ASC";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Tạo danh mục mới
     */
    public function create($name, $slug)
    {
        try {
            $data = [
                'name' => $name,
                'slug' => $slug
            ];

            $id = insert($this->conn, $this->table_name, $data);
            
            if ($id) {
                return $this->getById($id);
            }
            return false;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Cập nhật danh mục
     */
    public function update($id, $name, $slug)
    {
        try {
            $data = [
                'name' => $name,
                'slug' => $slug
            ];

            $result = update($this->conn, $this->table_name, $data, $id);
            
            if ($result) {
                return $this->getById($id);
            }
            return false;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Xóa danh mục
     */
    public function delete($id)
    {
        try {
            // Kiểm tra xem có bài viết nào thuộc danh mục này không
            $checkQuery = "SELECT COUNT(*) as count FROM posts WHERE post_category_id = :id";
            $checkStmt = $this->conn->prepare($checkQuery);
            $checkStmt->bindParam(':id', $id, PDO::PARAM_INT);
            $checkStmt->execute();
            $result = $checkStmt->fetch(PDO::FETCH_ASSOC);

            if ($result['count'] > 0) {
                throw new Exception('Không thể xóa danh mục vì còn bài viết thuộc danh mục này');
            }

            $query = "DELETE FROM " . $this->table_name . " WHERE id = :id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            return $stmt->execute();
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Đếm số bài viết trong danh mục
     */
    public function countPosts($categoryId)
    {
        try {
            $query = "SELECT COUNT(*) as count FROM posts WHERE post_category_id = :category_id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':category_id', $categoryId, PDO::PARAM_INT);
            $stmt->execute();
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return (int)($result['count'] ?? 0);
        } catch (PDOException $e) {
            return 0;
        }
    }
}

