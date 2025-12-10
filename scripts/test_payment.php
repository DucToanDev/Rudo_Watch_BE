<?php
/**
 * Script test payment endpoint
 * Sử dụng: php scripts/test_payment.php
 */

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/function.php';

// Kết nối database
$database = new Database();
$conn = $database->getConnection();

echo "=== Test Payment Setup ===\n\n";

// 1. Kiểm tra bảng tb_transactions
echo "1. Kiểm tra bảng tb_transactions...\n";
try {
    $stmt = $conn->query("SHOW TABLES LIKE 'tb_transactions'");
    if ($stmt->rowCount() > 0) {
        echo "   ✓ Bảng tb_transactions đã tồn tại\n";
    } else {
        echo "   ✗ Bảng tb_transactions chưa tồn tại. Cần chạy migration SQL.\n";
        echo "   File: database/migrations/create_tb_transactions.sql\n";
    }
} catch (Exception $e) {
    echo "   ✗ Lỗi: " . $e->getMessage() . "\n";
}

// 2. Kiểm tra đơn hàng
echo "\n2. Kiểm tra đơn hàng trong database...\n";
try {
    $stmt = $conn->query("SELECT id, user_id, total, payment_status, status FROM orders ORDER BY id DESC LIMIT 10");
    $orders = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if (count($orders) > 0) {
        echo "   Tìm thấy " . count($orders) . " đơn hàng gần nhất:\n";
        foreach ($orders as $order) {
            echo "   - Order #{$order['id']}: User ID={$order['user_id']}, Total={$order['total']}, Payment={$order['payment_status']}, Status={$order['status']}\n";
        }
    } else {
        echo "   ✗ Không có đơn hàng nào trong database\n";
    }
} catch (Exception $e) {
    echo "   ✗ Lỗi: " . $e->getMessage() . "\n";
}

// 3. Kiểm tra users
echo "\n3. Kiểm tra users trong database...\n";
try {
    $stmt = $conn->query("SELECT id, email, fullname FROM users ORDER BY id DESC LIMIT 5");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if (count($users) > 0) {
        echo "   Tìm thấy " . count($users) . " users gần nhất:\n";
        foreach ($users as $user) {
            echo "   - User #{$user['id']}: {$user['email']} ({$user['fullname']})\n";
        }
    } else {
        echo "   ✗ Không có user nào trong database\n";
    }
} catch (Exception $e) {
    echo "   ✗ Lỗi: " . $e->getMessage() . "\n";
}

// 4. Kiểm tra đơn hàng cụ thể
echo "\n4. Kiểm tra đơn hàng ID=12...\n";
try {
    $stmt = $conn->prepare("SELECT * FROM orders WHERE id = :id");
    $stmt->bindParam(':id', $orderId, PDO::PARAM_INT);
    $orderId = 12;
    $stmt->execute();
    $order = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($order) {
        echo "   ✓ Đơn hàng #12 tồn tại:\n";
        echo "   - User ID: {$order['user_id']}\n";
        echo "   - Total: {$order['total']}\n";
        echo "   - Payment Status: {$order['payment_status']}\n";
        echo "   - Status: {$order['status']}\n";
    } else {
        echo "   ✗ Đơn hàng #12 không tồn tại\n";
    }
} catch (Exception $e) {
    echo "   ✗ Lỗi: " . $e->getMessage() . "\n";
}

// 5. Kiểm tra SePay config
echo "\n5. Kiểm tra cấu hình SePay...\n";
$sepayConfig = [
    'SEPAY_API_KEY' => getenv('SEPAY_API_KEY') ?: ($_ENV['SEPAY_API_KEY'] ?? null),
    'SEPAY_ACCOUNT' => getenv('SEPAY_ACCOUNT') ?: ($_ENV['SEPAY_ACCOUNT'] ?? null),
    'SEPAY_BANK' => getenv('SEPAY_BANK') ?: ($_ENV['SEPAY_BANK'] ?? null),
];

foreach ($sepayConfig as $key => $value) {
    if ($value) {
        echo "   ✓ {$key}: " . (strlen($value) > 20 ? substr($value, 0, 20) . '...' : $value) . "\n";
    } else {
        echo "   ✗ {$key}: Chưa cấu hình\n";
    }
}

echo "\n=== Test hoàn tất ===\n";
echo "\nLưu ý:\n";
echo "- Nếu đơn hàng không tồn tại, hãy tạo đơn hàng mới trước\n";
echo "- Nếu đơn hàng không thuộc về user, hãy dùng order_id của user đang đăng nhập\n";
echo "- Đảm bảo đơn hàng có payment_status = 'unpaid'\n";

