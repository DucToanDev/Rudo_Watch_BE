-- Tạo bảng tb_transactions để lưu log giao dịch từ SePay
-- Tương tự như code mẫu sepay

CREATE TABLE IF NOT EXISTS `tb_transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gateway` varchar(100) DEFAULT NULL,
  `transaction_date` datetime DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `sub_account` varchar(50) DEFAULT NULL,
  `amount_in` decimal(12,2) DEFAULT '0.00',
  `amount_out` decimal(12,2) DEFAULT '0.00',
  `accumulated` decimal(12,2) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `transaction_content` text,
  `reference_number` varchar(150) DEFAULT NULL,
  `body` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_transaction_date` (`transaction_date`),
  KEY `idx_account_number` (`account_number`),
  KEY `idx_reference_number` (`reference_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

