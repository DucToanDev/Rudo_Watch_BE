<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/function.php';

class PaymentModel
{
    private $conn;
    private $table_name = 'payments';

    public function __construct()
    {
        $this->conn = Database::getInstance()->getConnection();
    }

    /**
     * Tạo giao dịch thanh toán
     */
    public function createPayment($orderId, $amount, $paymentMethod = 'sepay', $transactionId = null)
    {
        try {
            // Sử dụng cấu trúc database thực tế
            $data = [
                'order_id' => $orderId,
                'amount' => $amount,
                'gateway_name' => $paymentMethod, // gateway_name thay vì payment_method
                'gateway_transaction_id' => $transactionId, // gateway_transaction_id thay vì transaction_id
                'status' => 'pending'
            ];

            $id = insert($this->conn, $this->table_name, $data);

            if ($id) {
                return [
                    'success' => true,
                    'payment_id' => $id,
                    'data' => $data
                ];
            }

            return [
                'success' => false,
                'message' => 'Không thể tạo giao dịch thanh toán'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Cập nhật trạng thái thanh toán
     */
    public function updatePaymentStatus($paymentId, $status, $transactionId = null)
    {
        try {
            $updateData = [
                'status' => $status
            ];

            if ($transactionId) {
                $updateData['gateway_transaction_id'] = $transactionId; // gateway_transaction_id
            }

            $result = update($this->conn, $this->table_name, $updateData, $paymentId);

            if ($result) {
                return [
                    'success' => true,
                    'message' => 'Cập nhật trạng thái thanh toán thành công'
                ];
            }

            return [
                'success' => false,
                'message' => 'Không thể cập nhật trạng thái thanh toán'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Lấy thông tin thanh toán theo order_id
     */
    public function getPaymentByOrderId($orderId)
    {
        try {
            $query = "SELECT * FROM {$this->table_name} WHERE order_id = :order_id ORDER BY created_at DESC LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':order_id', $orderId, PDO::PARAM_INT);
            $stmt->execute();

            $payment = $stmt->fetch(PDO::FETCH_ASSOC);
            return $payment ?: null;
        } catch (PDOException $e) {
            return null;
        }
    }

    /**
     * Lấy thông tin thanh toán theo transaction_id
     */
    public function getPaymentByTransactionId($transactionId)
    {
        try {
            $query = "SELECT * FROM {$this->table_name} WHERE gateway_transaction_id = :transaction_id LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':transaction_id', $transactionId);
            $stmt->execute();

            $payment = $stmt->fetch(PDO::FETCH_ASSOC);
            return $payment ?: null;
        } catch (PDOException $e) {
            return null;
        }
    }

    /**
     * Đảm bảo bảng payments tồn tại (đã có sẵn trong DB, không cần tạo)
     */
    public function ensureTableExists()
    {
        // Bảng payments đã tồn tại trong database, không cần tạo mới
        return true;
    }
}

