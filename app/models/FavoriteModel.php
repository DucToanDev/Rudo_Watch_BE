<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';

class Favorites
{
    private $conn;
    private $table_name = 'favorites';
    public $response;

    // Các thuộc tính của favorite
    public $id;
    public $user_id;
    public $product_id;

    public function __construct()
    {
        $this->conn = Database::getInstance()->getConnection();
        $this->response = new Response();
    }

    // Lấy tất cả favorites của user
    public function getAllByUserId($userId, $params = [])
    {
        try {
            $query = "SELECT f.*, 
                             p.id as product_id,
                             p.name as product_name,
                             p.slug as product_slug,
                             p.image as product_image,
                             p.thumbnail as product_thumbnail,
                             p.status as product_status,
                             b.name as brand_name,
                             c.name as category_name,
                             (SELECT MIN(price) FROM product_variants WHERE product_id = p.id) as min_price,
                             (SELECT MAX(price) FROM product_variants WHERE product_id = p.id) as max_price
                      FROM " . $this->table_name . " f
                      INNER JOIN products p ON f.product_id = p.id
                      LEFT JOIN brands b ON p.brand_id = b.id
                      LEFT JOIN categories c ON p.category_id = c.id
                      WHERE f.user_id = :user_id";

            // Sắp xếp
            $orderBy = "ORDER BY f.id DESC";
            if (isset($params['sort_by'])) {
                $sortOrder = isset($params['sort_order']) && strtoupper($params['sort_order']) === 'ASC' ? 'ASC' : 'DESC';
                $allowedSorts = ['id', 'product_name'];
                if (in_array($params['sort_by'], $allowedSorts)) {
                    if ($params['sort_by'] === 'product_name') {
                        $orderBy = "ORDER BY p.name " . $sortOrder;
                    } else {
                        $orderBy = "ORDER BY f." . $params['sort_by'] . " " . $sortOrder;
                    }
                }
            }

            $query .= " " . $orderBy;

            // Phân trang
            $page = isset($params['page']) ? (int)$params['page'] : 1;
            $limit = isset($params['limit']) ? (int)$params['limit'] : 10;
            $offset = ($page - 1) * $limit;
            $query .= " LIMIT :limit OFFSET :offset";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
            $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);

            $stmt->execute();
            $favorites = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Đếm tổng số favorites
            $countQuery = "SELECT COUNT(*) as total FROM " . $this->table_name . " WHERE user_id = :user_id";
            $countStmt = $this->conn->prepare($countQuery);
            $countStmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            $countStmt->execute();
            $total = $countStmt->fetch(PDO::FETCH_ASSOC)['total'];

            return [
                'data' => $favorites,
                'pagination' => [
                    'current_page' => $page,
                    'per_page' => $limit,
                    'total' => (int)$total,
                    'total_pages' => ceil($total / $limit)
                ]
            ];
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Lấy favorite theo ID
    public function getById($id)
    {
        try {
            $query = "SELECT f.*, 
                             p.name as product_name,
                             p.slug as product_slug,
                             u.fullname as user_name
                      FROM " . $this->table_name . " f
                      LEFT JOIN products p ON f.product_id = p.id
                      LEFT JOIN users u ON f.user_id = u.id
                      WHERE f.id = :id";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();

            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Kiểm tra user đã favorite sản phẩm chưa
    public function isFavorite($userId, $productId)
    {
        try {
            $query = "SELECT id FROM " . $this->table_name . " 
                      WHERE user_id = :user_id AND product_id = :product_id";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            $stmt->bindParam(':product_id', $productId, PDO::PARAM_INT);
            $stmt->execute();

            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Lấy favorite của user cho sản phẩm
    public function getByUserAndProduct($userId, $productId)
    {
        try {
            $query = "SELECT f.*, 
                             p.name as product_name,
                             p.slug as product_slug
                      FROM " . $this->table_name . " f
                      LEFT JOIN products p ON f.product_id = p.id
                      WHERE f.user_id = :user_id AND f.product_id = :product_id";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            $stmt->bindParam(':product_id', $productId, PDO::PARAM_INT);
            $stmt->execute();

            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Tạo favorite mới
    public function create($userId, $productId)
    {
        try {
            // Kiểm tra đã favorite chưa
            $existing = $this->isFavorite($userId, $productId);
            if ($existing) {
                return ['success' => false, 'message' => 'Sản phẩm đã có trong danh sách yêu thích'];
            }

            $query = "INSERT INTO " . $this->table_name . " (user_id, product_id) 
                      VALUES (:user_id, :product_id)";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            $stmt->bindParam(':product_id', $productId, PDO::PARAM_INT);

            if ($stmt->execute()) {
                $lastId = $this->conn->lastInsertId();
                return ['success' => true, 'data' => $this->getById($lastId)];
            }

            return ['success' => false, 'message' => 'Không thể thêm vào danh sách yêu thích'];
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Xóa favorite theo ID
    public function delete($id)
    {
        try {
            $query = "DELETE FROM " . $this->table_name . " WHERE id = :id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            return $stmt->execute();
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Xóa favorite theo user_id và product_id
    public function deleteByUserAndProduct($userId, $productId)
    {
        try {
            $query = "DELETE FROM " . $this->table_name . " 
                      WHERE user_id = :user_id AND product_id = :product_id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            $stmt->bindParam(':product_id', $productId, PDO::PARAM_INT);
            return $stmt->execute();
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Đếm số lượng favorites của user
    public function countByUserId($userId)
    {
        try {
            $query = "SELECT COUNT(*) as total FROM " . $this->table_name . " WHERE user_id = :user_id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            $stmt->execute();
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return (int)$result['total'];
        } catch (PDOException $e) {
            throw $e;
        }
    }
}

