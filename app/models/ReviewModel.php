<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';

class Reviews
{
    private $conn;
    private $table_name = 'reviews';
    public $response;

    // Các thuộc tính của review
    public $id;
    public $user_id;
    public $product_id;
    public $content;
    public $rating;
    public $created_at;
    public $updated_at;

    public function __construct()
    {
        $this->conn = Database::getInstance()->getConnection();
        $this->response = new Response();
    }

    // Lấy tất cả reviews
    public function getAll($params = [])
    {
        try {
            $query = "SELECT r.*, u.fullname as user_name, u.email as user_email, 
                             p.name as product_name, p.slug as product_slug
                      FROM " . $this->table_name . " r
                      LEFT JOIN users u ON r.user_id = u.id
                      LEFT JOIN products p ON r.product_id = p.id";

            $conditions = [];
            $bindings = [];

            // Lọc theo product_id
            if (isset($params['product_id']) && !empty($params['product_id'])) {
                $conditions[] = "r.product_id = :product_id";
                $bindings[':product_id'] = $params['product_id'];
            }

            // Lọc theo user_id
            if (isset($params['user_id']) && !empty($params['user_id'])) {
                $conditions[] = "r.user_id = :user_id";
                $bindings[':user_id'] = $params['user_id'];
            }

            // Lọc theo rating
            if (isset($params['rating']) && $params['rating'] !== '') {
                $conditions[] = "r.rating = :rating";
                $bindings[':rating'] = $params['rating'];
            }

            // Sắp xếp
            $orderBy = "ORDER BY r.created_at DESC";
            if (isset($params['sort_by'])) {
                $sortOrder = isset($params['sort_order']) && strtoupper($params['sort_order']) === 'ASC' ? 'ASC' : 'DESC';
                $allowedSorts = ['rating', 'created_at'];
                if (in_array($params['sort_by'], $allowedSorts)) {
                    $orderBy = "ORDER BY r." . $params['sort_by'] . " " . $sortOrder;
                }
            }

            // Thêm điều kiện vào query
            if (!empty($conditions)) {
                $query .= " WHERE " . implode(" AND ", $conditions);
            }

            $query .= " " . $orderBy;

            // Phân trang
            $page = isset($params['page']) ? (int)$params['page'] : 1;
            $limit = isset($params['limit']) ? (int)$params['limit'] : 10;
            $offset = ($page - 1) * $limit;
            $query .= " LIMIT :limit OFFSET :offset";

            $stmt = $this->conn->prepare($query);

            foreach ($bindings as $key => $value) {
                $stmt->bindValue($key, $value);
            }
            $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
            $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);

            $stmt->execute();
            $reviews = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Đếm tổng số reviews
            $countQuery = "SELECT COUNT(*) as total FROM " . $this->table_name . " r";
            if (!empty($conditions)) {
                $countQuery .= " WHERE " . implode(" AND ", $conditions);
            }
            $countStmt = $this->conn->prepare($countQuery);
            foreach ($bindings as $key => $value) {
                $countStmt->bindValue($key, $value);
            }
            $countStmt->execute();
            $total = $countStmt->fetch(PDO::FETCH_ASSOC)['total'];

            return [
                'data' => $reviews,
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

    // Lấy reviews theo product_id
    public function getByProductId($productId, $params = [])
    {
        $params['product_id'] = $productId;
        return $this->getAll($params);
    }

    // Lấy review theo ID
    public function getById($id)
    {
        try {
            $query = "SELECT r.*, u.fullname as user_name, u.email as user_email, 
                             p.name as product_name, p.slug as product_slug
                      FROM " . $this->table_name . " r
                      LEFT JOIN users u ON r.user_id = u.id
                      LEFT JOIN products p ON r.product_id = p.id
                      WHERE r.id = :id";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id);
            $stmt->execute();

            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Tạo review mới
    public function create($data)
    {
        try {
            $query = "INSERT INTO " . $this->table_name . " 
                      (user_id, product_id, content, rating, created_at) 
                      VALUES (:user_id, :product_id, :content, :rating, NOW())";

            $stmt = $this->conn->prepare($query);

            $stmt->bindParam(':user_id', $data->user_id);
            $stmt->bindParam(':product_id', $data->product_id);
            $stmt->bindParam(':content', $data->content);
            $stmt->bindParam(':rating', $data->rating);

            if ($stmt->execute()) {
                $lastId = $this->conn->lastInsertId();
                return $this->getById($lastId);
            }

            return false;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Cập nhật review
    public function update($id, $data)
    {
        try {
            $fields = [];
            $bindings = [':id' => $id];

            if (isset($data->content)) {
                $fields[] = "content = :content";
                $bindings[':content'] = $data->content;
            }

            if (isset($data->rating)) {
                $fields[] = "rating = :rating";
                $bindings[':rating'] = $data->rating;
            }

            if (empty($fields)) {
                return $this->getById($id);
            }

            $fields[] = "updated_at = NOW()";

            $query = "UPDATE " . $this->table_name . " SET " . implode(", ", $fields) . " WHERE id = :id";

            $stmt = $this->conn->prepare($query);

            foreach ($bindings as $key => $value) {
                $stmt->bindValue($key, $value);
            }

            if ($stmt->execute()) {
                return $this->getById($id);
            }

            return false;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Xóa review
    public function delete($id)
    {
        try {
            $query = "DELETE FROM " . $this->table_name . " WHERE id = :id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id);
            return $stmt->execute();
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Lấy thống kê rating của sản phẩm
    public function getProductRatingStats($productId)
    {
        try {
            $query = "SELECT 
                        COUNT(*) as total_reviews,
                        AVG(rating) as average_rating,
                        SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) as five_star,
                        SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) as four_star,
                        SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) as three_star,
                        SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) as two_star,
                        SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) as one_star
                      FROM " . $this->table_name . " 
                      WHERE product_id = :product_id";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':product_id', $productId);
            $stmt->execute();

            $result = $stmt->fetch(PDO::FETCH_ASSOC);

            return [
                'total_reviews' => (int)$result['total_reviews'],
                'average_rating' => $result['average_rating'] ? round($result['average_rating'], 1) : 0,
                'rating_distribution' => [
                    '5' => (int)$result['five_star'],
                    '4' => (int)$result['four_star'],
                    '3' => (int)$result['three_star'],
                    '2' => (int)$result['two_star'],
                    '1' => (int)$result['one_star']
                ]
            ];
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Kiểm tra user đã review sản phẩm chưa
    public function hasUserReviewed($userId, $productId)
    {
        try {
            $query = "SELECT id FROM " . $this->table_name . " 
                      WHERE user_id = :user_id AND product_id = :product_id";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':user_id', $userId);
            $stmt->bindParam(':product_id', $productId);
            $stmt->execute();

            return $stmt->fetch(PDO::FETCH_ASSOC) ? true : false;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Lấy review của user cho sản phẩm
    public function getUserReview($userId, $productId)
    {
        try {
            $query = "SELECT r.*, u.fullname as user_name, u.email as user_email, 
                             p.name as product_name, p.slug as product_slug
                      FROM " . $this->table_name . " r
                      LEFT JOIN users u ON r.user_id = u.id
                      LEFT JOIN products p ON r.product_id = p.id
                      WHERE r.user_id = :user_id AND r.product_id = :product_id";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':user_id', $userId);
            $stmt->bindParam(':product_id', $productId);
            $stmt->execute();

            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    // Trả lời review (Admin)
    public function reply($id, $adminId, $replyContent, $status = 1)
    {
        try {
            $query = "UPDATE " . $this->table_name . " 
                      SET reply = :reply, 
                          admin_id = :admin_id, 
                          status = :status, 
                          updated_at = NOW() 
                      WHERE id = :id";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->bindParam(':reply', $replyContent);
            $stmt->bindParam(':admin_id', $adminId, PDO::PARAM_INT);
            $stmt->bindParam(':status', $status, PDO::PARAM_INT);

            if ($stmt->execute()) {
                return $this->getById($id);
            }

            return false;
        } catch (PDOException $e) {
            throw $e;
        }
    }
}
