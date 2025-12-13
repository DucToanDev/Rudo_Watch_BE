<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';

class Comments
{
    private $conn;
    private $table_name = 'comments';
    public $response;

    public function __construct()
    {
        $this->conn = Database::getInstance()->getConnection();
        $this->response = new Response();
    }

    /**
     * Lấy tất cả comments
     */
    public function getAll($params = [])
    {
        try {
            $query = "SELECT c.*, u.fullname as user_name, u.email as user_email, 
                             p.name as post_name, p.slug as post_slug
                      FROM " . $this->table_name . " c
                      LEFT JOIN users u ON c.user_id = u.id
                      LEFT JOIN posts p ON c.post_id = p.id";

            $conditions = [];
            $bindings = [];

            // Lọc theo post_id
            if (isset($params['post_id']) && !empty($params['post_id'])) {
                $conditions[] = "c.post_id = :post_id";
                $bindings[':post_id'] = $params['post_id'];
            }

            // Lọc theo user_id
            if (isset($params['user_id']) && !empty($params['user_id'])) {
                $conditions[] = "c.user_id = :user_id";
                $bindings[':user_id'] = $params['user_id'];
            }

            // Thêm điều kiện vào query
            if (!empty($conditions)) {
                $query .= " WHERE " . implode(" AND ", $conditions);
            }

            // Sắp xếp
            $orderBy = "ORDER BY c.created_at DESC";
            if (isset($params['sort_by'])) {
                $sortOrder = isset($params['sort_order']) && strtoupper($params['sort_order']) === 'ASC' ? 'ASC' : 'DESC';
                $allowedSorts = ['created_at'];
                if (in_array($params['sort_by'], $allowedSorts)) {
                    $orderBy = "ORDER BY c." . $params['sort_by'] . " " . $sortOrder;
                }
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
            $comments = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Đếm tổng số
            $countQuery = "SELECT COUNT(*) as total FROM " . $this->table_name . " c";
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
                'data' => $comments,
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

    /**
     * Lấy comments theo post_id
     */
    public function getByPostId($postId, $params = [])
    {
        $params['post_id'] = $postId;
        return $this->getAll($params);
    }

    /**
     * Lấy comment theo ID
     */
    public function getById($id)
    {
        try {
            $query = "SELECT c.*, u.fullname as user_name, u.email as user_email, 
                             p.name as post_name, p.slug as post_slug
                      FROM " . $this->table_name . " c
                      LEFT JOIN users u ON c.user_id = u.id
                      LEFT JOIN posts p ON c.post_id = p.id
                      WHERE c.id = :id";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id);
            $stmt->execute();

            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Tạo comment mới
     */
    public function create($data)
    {
        try {
            $query = "INSERT INTO " . $this->table_name . " 
                      (user_id, post_id, content, created_at) 
                      VALUES (:user_id, :post_id, :content, NOW())";

            $stmt = $this->conn->prepare($query);

            $stmt->bindParam(':user_id', $data->user_id);
            $stmt->bindParam(':post_id', $data->post_id);
            $stmt->bindParam(':content', $data->content);

            if ($stmt->execute()) {
                $lastId = $this->conn->lastInsertId();
                return $this->getById($lastId);
            }

            return false;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Cập nhật comment
     */
    public function update($id, $data)
    {
        try {
            $fields = [];
            $bindings = [':id' => $id];

            if (isset($data->content)) {
                $fields[] = "content = :content";
                $bindings[':content'] = $data->content;
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

    /**
     * Xóa comment
     */
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

    /**
     * Đếm số comment theo post_id
     */
    public function countByPostId($postId)
    {
        try {
            $query = "SELECT COUNT(*) as total FROM " . $this->table_name . " WHERE post_id = :post_id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':post_id', $postId, PDO::PARAM_INT);
            $stmt->execute();
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return (int)$result['total'];
        } catch (PDOException $e) {
            throw $e;
        }
    }
}

