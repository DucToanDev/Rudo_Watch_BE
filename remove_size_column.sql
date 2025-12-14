-- Script để xóa cột size khỏi bảng product_variants (nếu còn tồn tại)
-- Chạy script này nếu database vẫn còn cột size

-- Kiểm tra và xóa cột size nếu tồn tại
SET @dbname = DATABASE();
SET @tablename = 'product_variants';
SET @columnname = 'size';
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_schema = @dbname)
      AND (table_name = @tablename)
      AND (column_name = @columnname)
  ) > 0,
  CONCAT('ALTER TABLE `', @tablename, '` DROP COLUMN `', @columnname, '`;'),
  'SELECT "Column size does not exist in product_variants table" AS message;'
));
PREPARE alterIfExists FROM @preparedStatement;
EXECUTE alterIfExists;
DEALLOCATE PREPARE alterIfExists;

