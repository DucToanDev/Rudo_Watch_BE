<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';
require_once __DIR__ . '/../../config/function.php';

class ShippingMethodModel
{
    private $conn;
    private $table_name = 'shipping_method';
    public $response;

    public function __construct()
    {
        $this->conn = Database::getInstance()->getConnection();
        $this->response = new Response();
    }

    /**
     * Lấy tất cả phương thức vận chuyển đang hoạt động
     */
    public function getAll()
    {
        try {
            $query = "SELECT id, name, cost, status, created_at, updated_at 
                      FROM " . $this->table_name . " 
                      WHERE status = '1' 
                      ORDER BY cost ASC";

            $stmt = $this->conn->prepare($query);
            $stmt->execute();

            $methods = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Format cost thành số
            foreach ($methods as &$method) {
                $method['cost'] = (float)$method['cost'];
            }

            return [
                'success' => true,
                'data' => $methods
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi lấy danh sách phương thức vận chuyển: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Lấy tất cả phương thức vận chuyển (bao gồm cả inactive) - dành cho Admin
     */
    public function getAllAdmin()
    {
        try {
            $query = "SELECT id, name, cost, status, created_at, updated_at 
                      FROM " . $this->table_name . " 
                      ORDER BY id ASC";

            $stmt = $this->conn->prepare($query);
            $stmt->execute();

            $methods = $stmt->fetchAll(PDO::FETCH_ASSOC);

            foreach ($methods as &$method) {
                $method['cost'] = (float)$method['cost'];
                $method['status'] = $method['status'] === '1';
            }

            return [
                'success' => true,
                'data' => $methods
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Lấy phương thức vận chuyển theo ID
     */
    public function getById($id)
    {
        try {
            $query = "SELECT id, name, cost, status, created_at, updated_at 
                      FROM " . $this->table_name . " 
                      WHERE id = :id LIMIT 1";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();

            $method = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$method) {
                return [
                    'success' => false,
                    'message' => 'Không tìm thấy phương thức vận chuyển'
                ];
            }

            $method['cost'] = (float)$method['cost'];
            $method['status'] = $method['status'] === '1';

            return [
                'success' => true,
                'data' => $method
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Tạo phương thức vận chuyển mới
     */
    public function create($data)
    {
        try {
            $name = $data->name ?? null;
            $cost = $data->cost ?? 0;
            $status = $data->status ?? '1';

            if (!$name) {
                return [
                    'success' => false,
                    'message' => 'Vui lòng nhập tên phương thức vận chuyển'
                ];
            }

            $query = "INSERT INTO " . $this->table_name . " (name, cost, status, created_at) 
                      VALUES (:name, :cost, :status, NOW())";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':name', $name);
            $stmt->bindParam(':cost', $cost);
            $stmt->bindParam(':status', $status);
            $stmt->execute();

            $newId = $this->conn->lastInsertId();

            return [
                'success' => true,
                'message' => 'Tạo phương thức vận chuyển thành công',
                'data' => $this->getById($newId)['data']
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi tạo phương thức vận chuyển: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Cập nhật phương thức vận chuyển
     */
    public function update($id, $data)
    {
        try {
            // Kiểm tra tồn tại
            $existing = $this->getById($id);
            if (!$existing['success']) {
                return $existing;
            }

            $name = $data->name ?? $existing['data']['name'];
            $cost = $data->cost ?? $existing['data']['cost'];
            $status = isset($data->status) ? ($data->status ? '1' : '0') : ($existing['data']['status'] ? '1' : '0');

            $query = "UPDATE " . $this->table_name . " 
                      SET name = :name, cost = :cost, status = :status, updated_at = NOW() 
                      WHERE id = :id";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':name', $name);
            $stmt->bindParam(':cost', $cost);
            $stmt->bindParam(':status', $status);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();

            return [
                'success' => true,
                'message' => 'Cập nhật phương thức vận chuyển thành công',
                'data' => $this->getById($id)['data']
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi cập nhật: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Xóa phương thức vận chuyển
     */
    public function delete($id)
    {
        try {
            // Kiểm tra tồn tại
            $existing = $this->getById($id);
            if (!$existing['success']) {
                return $existing;
            }

            $query = "DELETE FROM " . $this->table_name . " WHERE id = :id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();

            return [
                'success' => true,
                'message' => 'Xóa phương thức vận chuyển thành công'
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi xóa: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Tính phí vận chuyển dựa trên tổng đơn hàng
     * Nếu đơn hàng trên 500k và có phương thức miễn phí -> trả về phương thức miễn phí
     */
    public function calculateShipping($methodId, $orderTotal)
    {
        try {
            $method = $this->getById($methodId);
            if (!$method['success']) {
                return $method;
            }

            $shippingCost = $method['data']['cost'];

            // Kiểm tra nếu có phương thức miễn phí cho đơn hàng lớn
            if ($orderTotal >= 500000) {
                $freeShipping = $this->getFreeShippingMethod();
                if ($freeShipping) {
                    return [
                        'success' => true,
                        'data' => [
                            'method_id' => $freeShipping['id'],
                            'method_name' => $freeShipping['name'],
                            'original_cost' => $shippingCost,
                            'final_cost' => 0,
                            'free_shipping_applied' => true,
                            'message' => 'Miễn phí vận chuyển cho đơn hàng trên 500.000đ'
                        ]
                    ];
                }
            }

            return [
                'success' => true,
                'data' => [
                    'method_id' => $method['data']['id'],
                    'method_name' => $method['data']['name'],
                    'original_cost' => $shippingCost,
                    'final_cost' => $shippingCost,
                    'free_shipping_applied' => false
                ]
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Lấy phương thức vận chuyển miễn phí
     */
    private function getFreeShippingMethod()
    {
        $query = "SELECT * FROM " . $this->table_name . " 
                  WHERE cost = 0 AND status = '1' LIMIT 1";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
}
