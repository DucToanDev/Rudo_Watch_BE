<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';
require_once __DIR__ . '/../../config/function.php';

class Posts
{
    private $conn;
    private $table_name = 'posts';
    public $response;

    public $id;
    public $user_id;
    public $post_category_id;
    public $name;
    public $slug;
    public $image;
    public $content;
    public $created_at;
    public $updated_at;

    public function __construct()
    {
        $database = new Database();
        $this->conn = $database->getConnection();
        $this->response = new Response();
    }

    /**
     * Lấy tất cả bài viết
     */
    public function getAll($params = [])
    {
        try {
            $query = "SELECT p.*, 
                        pc.name as category_name, 
                        pc.slug as category_slug,
                        u.fullname as author_name
                      FROM " . $this->table_name . " p
                      LEFT JOIN posts_categories pc ON p.post_category_id = pc.id
                      LEFT JOIN users u ON p.user_id = u.id";
            
            $conditions = [];
            $bindings = [];

            // Tìm kiếm theo name
            if (isset($params['search']) && !empty($params['search'])) {
                $conditions[] = "p.name LIKE :search";
                $bindings[':search'] = '%' . $params['search'] . '%';
            }

            // Lọc theo category
            if (isset($params['category_id']) && !empty($params['category_id'])) {
                $conditions[] = "p.post_category_id = :category_id";
                $bindings[':category_id'] = $params['category_id'];
            }

            // Lọc theo author
            if (isset($params['author_id']) && !empty($params['author_id'])) {
                $conditions[] = "p.user_id = :author_id";
                $bindings[':author_id'] = $params['author_id'];
            }

            if (!empty($conditions)) {
                $query .= " WHERE " . implode(" AND ", $conditions);
            }

            // Sắp xếp
            $sortBy = $params['sort_by'] ?? 'created_at';
            $sortOrder = $params['sort_order'] ?? 'DESC';
            $query .= " ORDER BY p." . $sortBy . " " . $sortOrder;

            // Phân trang
            if (isset($params['page']) && isset($params['limit'])) {
                $page = (int)$params['page'];
                $limit = (int)$params['limit'];
                $offset = ($page - 1) * $limit;
                $query .= " LIMIT :limit OFFSET :offset";
            }

            $stmt = $this->conn->prepare($query);
            foreach ($bindings as $key => $value) {
                $stmt->bindValue($key, $value);
            }
            
            if (isset($params['page']) && isset($params['limit'])) {
                $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
                $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
            }
            
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Lấy bài viết theo ID
     */
    public function getById($id)
    {
        try {
            $query = "SELECT p.*, 
                        pc.name as category_name, 
                        pc.slug as category_slug,
                        u.fullname as author_name,
                        u.email as author_email
                      FROM " . $this->table_name . " p
                      LEFT JOIN posts_categories pc ON p.post_category_id = pc.id
                      LEFT JOIN users u ON p.user_id = u.id
                      WHERE p.id = :id LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Lấy bài viết theo slug
     */
    public function getBySlug($slug)
    {
        try {
            $query = "SELECT p.*, 
                        pc.name as category_name, 
                        pc.slug as category_slug,
                        u.fullname as author_name,
                        u.email as author_email
                      FROM " . $this->table_name . " p
                      LEFT JOIN posts_categories pc ON p.post_category_id = pc.id
                      LEFT JOIN users u ON p.user_id = u.id
                      WHERE p.slug = :slug LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':slug', $slug);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Lấy bài viết đã published (tất cả vì không có status field)
     */
    public function getPublished($limit = null)
    {
        try {
            $query = "SELECT p.*, 
                        pc.name as category_name, 
                        pc.slug as category_slug,
                        u.fullname as author_name
                      FROM " . $this->table_name . " p
                      LEFT JOIN posts_categories pc ON p.post_category_id = pc.id
                      LEFT JOIN users u ON p.user_id = u.id
                      ORDER BY p.created_at DESC";
            
            if ($limit) {
                $query .= " LIMIT :limit";
            }
            
            $stmt = $this->conn->prepare($query);
            if ($limit) {
                $stmt->bindValue(':limit', (int)$limit, PDO::PARAM_INT);
            }
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Lấy bài viết theo category
     */
    public function getByCategory($categoryId, $limit = null)
    {
        try {
            $query = "SELECT p.*, 
                        pc.name as category_name, 
                        pc.slug as category_slug,
                        u.fullname as author_name
                      FROM " . $this->table_name . " p
                      LEFT JOIN posts_categories pc ON p.post_category_id = pc.id
                      LEFT JOIN users u ON p.user_id = u.id
                      WHERE p.post_category_id = :category_id 
                      ORDER BY p.created_at DESC";
            
            if ($limit) {
                $query .= " LIMIT :limit";
            }
            
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':category_id', $categoryId, PDO::PARAM_INT);
            if ($limit) {
                $stmt->bindValue(':limit', (int)$limit, PDO::PARAM_INT);
            }
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Tạo bài viết mới
     */
    public function create($data, $image = null)
    {
        try {
            $postData = [
                'user_id' => $data->user_id,
                'post_category_id' => $data->post_category_id,
                'name' => $data->name,
                'slug' => $data->slug,
                'content' => $data->content,
                'image' => $image
            ];

            $id = insert($this->conn, $this->table_name, $postData);
            
            if ($id) {
                return $this->getById($id);
            }
            return false;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Cập nhật bài viết
     */
    public function update($id, $data, $image = null)
    {
        try {
            $updateData = [];

            if (isset($data->post_category_id)) {
                $updateData['post_category_id'] = $data->post_category_id;
            }
            if (isset($data->name)) {
                $updateData['name'] = $data->name;
            }
            if (isset($data->slug)) {
                $updateData['slug'] = $data->slug;
            }
            if (isset($data->content)) {
                $updateData['content'] = $data->content;
            }
            if ($image !== null) {
                $updateData['image'] = $image;
            }

            $result = update($this->conn, $this->table_name, $updateData, $id);
            
            if ($result) {
                return $this->getById($id);
            }
            return false;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Xóa bài viết
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
     * Tăng số lượt xem (không có field views trong DB, giữ lại để tương thích)
     */
    public function incrementViews($id)
    {
        // Không có field views trong database, bỏ qua
        return true;
    }
}
