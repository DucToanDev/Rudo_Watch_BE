<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/function.php';

class TransactionModel
{
    private $conn;
    private $table_name = 'tb_transactions';

    public function __construct()
    {
        $database = new Database();
        $this->conn = $database->getConnection();
    }

    /**
     * Tạo giao dịch mới từ webhook SePay
     */
    public function createTransaction($data)
    {
        try {
            $query = "INSERT INTO {$this->table_name} 
                     (gateway, transaction_date, account_number, sub_account, amount_in, amount_out, accumulated, code, transaction_content, reference_number, body) 
                     VALUES (:gateway, :transaction_date, :account_number, :sub_account, :amount_in, :amount_out, :accumulated, :code, :transaction_content, :reference_number, :body)";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':gateway', $data['gateway']);
            $stmt->bindParam(':transaction_date', $data['transaction_date']);
            $stmt->bindParam(':account_number', $data['account_number']);
            $stmt->bindParam(':sub_account', $data['sub_account']);
            $stmt->bindParam(':amount_in', $data['amount_in']);
            $stmt->bindParam(':amount_out', $data['amount_out']);
            $stmt->bindParam(':accumulated', $data['accumulated']);
            $stmt->bindParam(':code', $data['code']);
            $stmt->bindParam(':transaction_content', $data['transaction_content']);
            $stmt->bindParam(':reference_number', $data['reference_number']);
            $stmt->bindParam(':body', $data['body']);

            $stmt->execute();
            $transactionId = $this->conn->lastInsertId();

            return [
                'success' => true,
                'transaction_id' => $transactionId
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi lưu giao dịch: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Lấy giao dịch theo reference_number
     */
    public function getTransactionByReference($referenceNumber)
    {
        try {
            $query = "SELECT * FROM {$this->table_name} WHERE reference_number = :reference_number ORDER BY created_at DESC LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':reference_number', $referenceNumber);
            $stmt->execute();

            return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
        } catch (PDOException $e) {
            return null;
        }
    }
}

