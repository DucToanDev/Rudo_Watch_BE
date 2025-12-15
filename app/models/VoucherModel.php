<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';
require_once __DIR__ . '/../../config/function.php';

class Vouchers
{
    private $conn;
    private $table_name = 'vouchers';
    public $response;

    public function __construct()
    {
        $this->conn = Database::getInstance()->getConnection();
        $this->response = new Response();
    }

    /**
     * Lấy tất cả vouchers
     */
    public function getAll($params = [])
    {
        try {
            $query = "SELECT * FROM " . $this->table_name . " WHERE 1=1";
            $conditions = [];
            $bindings = [];

            // Tìm kiếm theo code
            if (isset($params['search']) && !empty($params['search'])) {
                $conditions[] = "code LIKE :search";
                $bindings[':search'] = '%' . $params['search'] . '%';
            }

            // Lọc theo type
            if (isset($params['type']) && !empty($params['type'])) {
                $conditions[] = "type = :type";
                $bindings[':type'] = $params['type'];
            }

            // Lọc voucher còn hạn
            if (isset($params['valid']) && $params['valid'] === 'true') {
                $conditions[] = "(start_at IS NULL OR start_at <= NOW()) AND (expired_at IS NULL OR expired_at > NOW())";
            }

            if (!empty($conditions)) {
                $query .= " AND " . implode(" AND ", $conditions);
            }

            $query .= " ORDER BY created_at DESC";

            // Phân trang
            if (isset($params['page']) || isset($params['limit'])) {
                $page = isset($params['page']) ? (int)$params['page'] : 1;
                $limit = isset($params['limit']) ? (int)$params['limit'] : 10;
                $offset = ($page - 1) * $limit;
                $query .= " LIMIT :limit OFFSET :offset";
            }

            $stmt = $this->conn->prepare($query);

            foreach ($bindings as $key => $value) {
                $stmt->bindValue($key, $value);
            }

            if (isset($params['page']) || isset($params['limit'])) {
                $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
                $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
            }

            $stmt->execute();
            $vouchers = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Thêm thông tin trạng thái
            foreach ($vouchers as &$voucher) {
                $voucher['is_expired'] = $voucher['expired_at'] && strtotime($voucher['expired_at']) < time();
                $voucher['is_not_started'] = $voucher['start_at'] && strtotime($voucher['start_at']) > time();
            }

            if (isset($params['page']) || isset($params['limit'])) {
                $countQuery = "SELECT COUNT(*) as total FROM " . $this->table_name . " WHERE 1=1";
                if (!empty($conditions)) {
                    $countQuery .= " AND " . implode(" AND ", $conditions);
                }
                $countStmt = $this->conn->prepare($countQuery);
                foreach ($bindings as $key => $value) {
                    $countStmt->bindValue($key, $value);
                }
                $countStmt->execute();
                $total = $countStmt->fetch(PDO::FETCH_ASSOC)['total'];

                return [
                    'data' => $vouchers,
                    'pagination' => [
                        'current_page' => $page,
                        'per_page' => $limit,
                        'total' => (int)$total,
                        'total_pages' => ceil($total / $limit)
                    ]
                ];
            }

            return $vouchers;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Lấy voucher theo ID
     */
    public function getById($id)
    {
        try {
            $query = "SELECT * FROM " . $this->table_name . " WHERE id = :id LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();
            $voucher = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($voucher) {
                $voucher['is_expired'] = $voucher['expired_at'] && strtotime($voucher['expired_at']) < time();
                $voucher['is_not_started'] = $voucher['start_at'] && strtotime($voucher['start_at']) > time();
            }

            return $voucher ?: null;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Lấy voucher theo code
     */
    public function getByCode($code)
    {
        try {
            $query = "SELECT * FROM " . $this->table_name . " WHERE code = :code LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':code', $code);
            $stmt->execute();
            $voucher = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($voucher) {
                $voucher['is_expired'] = $voucher['expired_at'] && strtotime($voucher['expired_at']) < time();
                $voucher['is_not_started'] = $voucher['start_at'] && strtotime($voucher['start_at']) > time();
            }

            return $voucher ?: null;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Kiểm tra code đã tồn tại chưa
     */
    public function codeExists($code, $excludeId = null)
    {
        try {
            $query = "SELECT id FROM " . $this->table_name . " WHERE code = :code";
            if ($excludeId) {
                $query .= " AND id != :exclude_id";
            }
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':code', $code);
            if ($excludeId) {
                $stmt->bindParam(':exclude_id', $excludeId, PDO::PARAM_INT);
            }
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC) ? true : false;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Tạo voucher mới
     */
    public function create($data)
    {
        try {
            // Xử lý discount/amount: ưu tiên amount nếu có, nếu không thì dùng discount
            $moneyValue = null;
            if ($data->type === 'money') {
                $moneyValue = isset($data->amount) && $data->amount !== '' ? (float)$data->amount : (isset($data->discount) && $data->discount !== '' ? (float)$data->discount : null);
            }
            
            $insertData = [
                'code' => strtoupper($data->code),
                'type' => $data->type,
                'discount' => $data->type === 'percent' ? (int)$data->discount : null,
                'amount' => $moneyValue,
                'start_at' => $data->start_at ?? null,
                'expired_at' => $data->expired_at ?? null,
                'usage_limit' => isset($data->usage_limit) ? (int)$data->usage_limit : null
            ];

            $id = insert($this->conn, $this->table_name, $insertData);
            return $id ? $this->getById($id) : null;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Cập nhật voucher
     */
    public function update($id, $data)
    {
        try {
            $existing = $this->getById($id);
            if (!$existing) {
                return null;
            }

            $updateData = [
                'code' => isset($data->code) ? strtoupper($data->code) : $existing['code'],
                'type' => $data->type ?? $existing['type'],
                'discount' => null,
                'amount' => null
            ];

            // Xử lý discount/amount theo type
            $type = $updateData['type'];
            if ($type === 'percent') {
                $updateData['discount'] = isset($data->discount) ? (int)$data->discount : $existing['discount'];
            } else {
                // Ưu tiên amount nếu có, nếu không thì dùng discount
                $moneyValue = isset($data->amount) && $data->amount !== '' ? (float)$data->amount : (isset($data->discount) && $data->discount !== '' ? (float)$data->discount : null);
                $updateData['amount'] = $moneyValue !== null ? $moneyValue : $existing['amount'];
            }

            if (isset($data->start_at)) {
                $updateData['start_at'] = $data->start_at;
            }

            if (isset($data->expired_at)) {
                $updateData['expired_at'] = $data->expired_at;
            }

            // Xử lý usage_limit
            if (isset($data->usage_limit)) {
                $updateData['usage_limit'] = (int)$data->usage_limit;
            }

            $result = update($this->conn, $this->table_name, $updateData, $id);
            return $result ? $this->getById($id) : null;
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Xóa voucher
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
     * Áp dụng voucher - kiểm tra và tính giảm giá
     */
    public function apply($code, $totalAmount)
    {
        try {
            $voucher = $this->getByCode($code);

            if (!$voucher) {
                return ['success' => false, 'message' => 'Mã giảm giá không tồn tại'];
            }

            // Kiểm tra ngày bắt đầu
            if ($voucher['start_at'] && strtotime($voucher['start_at']) > time()) {
                return ['success' => false, 'message' => 'Mã giảm giá chưa đến thời gian sử dụng'];
            }

            if ($voucher['is_expired']) {
                return ['success' => false, 'message' => 'Mã giảm giá đã hết hạn'];
            }

            $discountAmount = 0;
            if ($voucher['type'] === 'percent') {
                $discountAmount = ($totalAmount * $voucher['discount']) / 100;
            } else {
                $discountAmount = (float)$voucher['amount'];
            }

            // Không cho giảm quá tổng tiền
            if ($discountAmount > $totalAmount) {
                $discountAmount = $totalAmount;
            }

            return [
                'success' => true,
                'voucher' => $voucher,
                'discount_amount' => $discountAmount,
                'final_amount' => $totalAmount - $discountAmount
            ];
        } catch (PDOException $e) {
            throw $e;
        }
    }

    /**
     * Đếm số đơn hàng sử dụng voucher
     */
    public function countUsage($voucherId)
    {
        try {
            $query = "SELECT COUNT(*) as total FROM orders WHERE voucher_id = :voucher_id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':voucher_id', $voucherId, PDO::PARAM_INT);
            $stmt->execute();
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return (int)$result['total'];
        } catch (PDOException $e) {
            throw $e;
        }
    }
}