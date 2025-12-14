<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';
require_once __DIR__ . '/../../config/function.php';

class OrderModel
{
    private $conn;
    private $table_name = 'orders';
    private $order_detail_table = 'order_detail';
    private $payments_table = 'payments';
    public $response;

    public function __construct()
    {
        $this->conn = Database::getInstance()->getConnection();
        $this->response = new Response();
    }

    /**
     * Lấy danh sách đơn hàng của user
     */
    public function getOrdersByUserId($userId, $params = [])
    {
        try {
            $page = isset($params['page']) ? (int)$params['page'] : 1;
            $limit = isset($params['limit']) ? (int)$params['limit'] : 10;
            $status = $params['status'] ?? null;
            $offset = ($page - 1) * $limit;

            // Query đếm tổng
            $countQuery = "SELECT COUNT(*) as total FROM " . $this->table_name . " WHERE user_id = :user_id";
            if ($status) {
                $countQuery .= " AND status = :status";
            }

            $countStmt = $this->conn->prepare($countQuery);
            $countStmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            if ($status) {
                $countStmt->bindParam(':status', $status, PDO::PARAM_STR);
            }
            $countStmt->execute();
            $total = $countStmt->fetch(PDO::FETCH_ASSOC)['total'];

            // Query lấy danh sách
            $query = "SELECT o.*, 
                             (SELECT COUNT(*) FROM " . $this->order_detail_table . " od WHERE od.order_id = o.id) as total_items
                      FROM " . $this->table_name . " o
                      WHERE o.user_id = :user_id";

            if ($status) {
                $query .= " AND o.status = :status";
            }

            $query .= " ORDER BY o.created_at DESC LIMIT :limit OFFSET :offset";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            if ($status) {
                $stmt->bindParam(':status', $status, PDO::PARAM_STR);
            }
            $stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
            $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
            $stmt->execute();

            $orders = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Format data
            foreach ($orders as &$order) {
                $order['total'] = (float)$order['total'];
                $order['address'] = json_decode($order['address'], true);
            }

            return [
                'success' => true,
                'data' => [
                    'orders' => $orders,
                    'pagination' => [
                        'current_page' => $page,
                        'per_page' => $limit,
                        'total' => (int)$total,
                        'total_pages' => ceil($total / $limit)
                    ]
                ]
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi lấy danh sách đơn hàng: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Lấy chi tiết đơn hàng
     */
    public function getOrderById($orderId, $userId = null)
    {
        try {
            $query = "SELECT o.* FROM " . $this->table_name . " o WHERE o.id = :order_id";

            // Nếu có userId, chỉ lấy đơn hàng của user đó
            if ($userId) {
                $query .= " AND o.user_id = :user_id";
            }

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':order_id', $orderId, PDO::PARAM_INT);
            if ($userId) {
                $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            }
            $stmt->execute();

            $order = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$order) {
                return [
                    'success' => false,
                    'message' => 'Không tìm thấy đơn hàng'
                ];
            }

            // Lấy chi tiết sản phẩm trong đơn hàng
            $detailQuery = "SELECT od.*, 
                                   pv.product_id, pv.sku, pv.image as variant_image, pv.colors,
                                   p.name as product_name, p.slug as product_slug, p.image as product_image
                            FROM " . $this->order_detail_table . " od
                            LEFT JOIN product_variants pv ON od.variant_id = pv.id
                            LEFT JOIN products p ON pv.product_id = p.id
                            WHERE od.order_id = :order_id";

            $detailStmt = $this->conn->prepare($detailQuery);
            $detailStmt->bindParam(':order_id', $orderId, PDO::PARAM_INT);
            $detailStmt->execute();

            $items = $detailStmt->fetchAll(PDO::FETCH_ASSOC);

            // Lấy thông tin thanh toán
            $paymentQuery = "SELECT * FROM " . $this->payments_table . " WHERE order_id = :order_id";
            $paymentStmt = $this->conn->prepare($paymentQuery);
            $paymentStmt->bindParam(':order_id', $orderId, PDO::PARAM_INT);
            $paymentStmt->execute();
            $payment = $paymentStmt->fetch(PDO::FETCH_ASSOC);

            // Format data
            $order['total'] = (float)$order['total'];
            $order['address'] = json_decode($order['address'], true);

            foreach ($items as &$item) {
                $item['price'] = (float)$item['price'];
                $item['subtotal'] = $item['price'] * $item['quantity'];
                if ($item['colors']) {
                    $item['colors'] = json_decode($item['colors'], true);
                }
            }

            $order['items'] = $items;
            $order['payment'] = $payment;

            return [
                'success' => true,
                'data' => $order
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi lấy chi tiết đơn hàng: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Tạo đơn hàng mới
     */
    public function createOrder($userId, $data)
    {
        try {
            $this->conn->beginTransaction();

            // Validate dữ liệu
            $items = $data->items ?? [];
            $addressData = $data->address ?? null;
            $paymentMethod = $data->payment_method ?? 'cod';
            $note = $data->note ?? null;
            $voucherId = $data->voucher_id ?? null;
            $shippingMethodId = $data->shipping_method_id ?? null;

            if (empty($items)) {
                return [
                    'success' => false,
                    'message' => 'Giỏ hàng trống'
                ];
            }

            if (!$addressData) {
                return [
                    'success' => false,
                    'message' => 'Vui lòng cung cấp địa chỉ giao hàng'
                ];
            }

            // Tính tổng tiền và validate sản phẩm
            $total = 0;
            $orderItems = [];

            foreach ($items as $item) {
                $variantId = $item->variant_id ?? null;
                $quantity = $item->quantity ?? 1;

                if (!$variantId) {
                    $this->conn->rollBack();
                    return [
                        'success' => false,
                        'message' => 'Thiếu thông tin variant_id'
                    ];
                }

                // Lấy thông tin variant
                $variant = $this->getVariant($variantId);
                if (!$variant) {
                    $this->conn->rollBack();
                    return [
                        'success' => false,
                        'message' => 'Biến thể sản phẩm không tồn tại: ' . $variantId
                    ];
                }

                // Kiểm tra tồn kho
                if ($variant['quantity'] < $quantity) {
                    $this->conn->rollBack();
                    return [
                        'success' => false,
                        'message' => 'Sản phẩm "' . $variant['product_name'] . '" không đủ số lượng (còn ' . $variant['quantity'] . ')'
                    ];
                }

                $price = (float)$variant['price'];
                $total += $price * $quantity;

                $orderItems[] = [
                    'variant_id' => $variantId,
                    'quantity' => $quantity,
                    'price' => $price
                ];
            }

            // Tính phí vận chuyển nếu có
            $shippingCost = 0;
            if ($shippingMethodId) {
                $shippingMethod = $this->getShippingMethod($shippingMethodId);
                if ($shippingMethod) {
                    $shippingCost = (float)$shippingMethod['cost'];
                    $total += $shippingCost;
                }
            }

            // Áp dụng voucher nếu có
            $discount = 0;
            if ($voucherId) {
                $voucher = $this->getVoucher($voucherId);
                if ($voucher && $this->isVoucherValid($voucher, $total)) {
                    if ($voucher['type'] === 'percent') {
                        $discount = $total * ($voucher['value'] / 100);
                        if ($voucher['max_discount'] && $discount > $voucher['max_discount']) {
                            $discount = $voucher['max_discount'];
                        }
                    } else {
                        $discount = $voucher['value'];
                    }
                    $total -= $discount;
                }
            }

            // Tạo đơn hàng
            $addressJson = json_encode($addressData, JSON_UNESCAPED_UNICODE);
            $orderQuery = "INSERT INTO " . $this->table_name . " 
                          (user_id, voucher_id, address, status, payment_method, payment_status, total, note, created_at, updated_at) 
                          VALUES (:user_id, :voucher_id, :address, 'pending', :payment_method, 'unpaid', :total, :note, NOW(), NOW())";

            $orderStmt = $this->conn->prepare($orderQuery);
            $orderStmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            $orderStmt->bindParam(':voucher_id', $voucherId, PDO::PARAM_INT);
            $orderStmt->bindParam(':address', $addressJson, PDO::PARAM_STR);
            $orderStmt->bindParam(':payment_method', $paymentMethod, PDO::PARAM_STR);
            $orderStmt->bindParam(':total', $total, PDO::PARAM_STR);
            $orderStmt->bindParam(':note', $note, PDO::PARAM_STR);
            $orderStmt->execute();

            $orderId = $this->conn->lastInsertId();

            // Tạo chi tiết đơn hàng
            foreach ($orderItems as $orderItem) {
                $detailQuery = "INSERT INTO " . $this->order_detail_table . " 
                               (order_id, variant_id, quantity, price) 
                               VALUES (:order_id, :variant_id, :quantity, :price)";

                $detailStmt = $this->conn->prepare($detailQuery);
                $detailStmt->bindParam(':order_id', $orderId, PDO::PARAM_INT);
                $detailStmt->bindParam(':variant_id', $orderItem['variant_id'], PDO::PARAM_INT);
                $detailStmt->bindParam(':quantity', $orderItem['quantity'], PDO::PARAM_INT);
                $detailStmt->bindParam(':price', $orderItem['price'], PDO::PARAM_STR);
                $detailStmt->execute();

                // Trừ tồn kho
                $this->updateVariantStock($orderItem['variant_id'], -$orderItem['quantity']);
            }

            // Xóa giỏ hàng của user
            $this->clearUserCart($userId);

            $this->conn->commit();

            // Lấy chi tiết đơn hàng vừa tạo
            return $this->getOrderById($orderId, $userId);
        } catch (PDOException $e) {
            $this->conn->rollBack();
            return [
                'success' => false,
                'message' => 'Lỗi khi tạo đơn hàng: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Cập nhật trạng thái đơn hàng (Admin)
     */
    public function updateStatus($orderId, $status)
    {
        try {
            $validStatuses = ['pending', 'confirmed', 'processing', 'shipping', 'delivered', 'cancelled'];
            if (!in_array($status, $validStatuses)) {
                return [
                    'success' => false,
                    'message' => 'Trạng thái không hợp lệ. Các trạng thái hợp lệ: ' . implode(', ', $validStatuses)
                ];
            }

            $query = "UPDATE " . $this->table_name . " SET status = :status, updated_at = NOW() WHERE id = :id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':status', $status, PDO::PARAM_STR);
            $stmt->bindParam(':id', $orderId, PDO::PARAM_INT);
            $stmt->execute();

            if ($stmt->rowCount() === 0) {
                return [
                    'success' => false,
                    'message' => 'Không tìm thấy đơn hàng'
                ];
            }

            // Nếu hủy đơn hàng, hoàn lại tồn kho
            if ($status === 'cancelled') {
                $this->restoreStock($orderId);
            }

            return [
                'success' => true,
                'message' => 'Cập nhật trạng thái thành công'
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi cập nhật trạng thái: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Hủy đơn hàng (User)
     */
    public function cancelOrder($orderId, $userId)
    {
        try {
            // Kiểm tra đơn hàng thuộc về user và có thể hủy
            $query = "SELECT * FROM " . $this->table_name . " WHERE id = :id AND user_id = :user_id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $orderId, PDO::PARAM_INT);
            $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
            $stmt->execute();

            $order = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$order) {
                return [
                    'success' => false,
                    'message' => 'Không tìm thấy đơn hàng'
                ];
            }

            // Chỉ có thể hủy đơn hàng ở trạng thái pending hoặc confirmed
            if (!in_array($order['status'], ['pending', 'confirmed'])) {
                return [
                    'success' => false,
                    'message' => 'Không thể hủy đơn hàng ở trạng thái này'
                ];
            }

            // Cập nhật trạng thái
            $updateQuery = "UPDATE " . $this->table_name . " SET status = 'cancelled', updated_at = NOW() WHERE id = :id";
            $updateStmt = $this->conn->prepare($updateQuery);
            $updateStmt->bindParam(':id', $orderId, PDO::PARAM_INT);
            $updateStmt->execute();

            // Hoàn lại tồn kho
            $this->restoreStock($orderId);

            return [
                'success' => true,
                'message' => 'Đã hủy đơn hàng thành công'
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi hủy đơn hàng: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Lấy tất cả đơn hàng (Admin)
     */
    public function getAllOrders($params = [])
    {
        try {
            $page = isset($params['page']) ? (int)$params['page'] : 1;
            $limit = isset($params['limit']) ? (int)$params['limit'] : 10;
            $status = $params['status'] ?? null;
            $search = $params['search'] ?? null;
            $offset = ($page - 1) * $limit;

            // Query đếm tổng
            $countQuery = "SELECT COUNT(*) as total FROM " . $this->table_name . " o
                          LEFT JOIN users u ON o.user_id = u.id WHERE 1=1";

            $conditions = [];
            $bindParams = [];

            if ($status) {
                $conditions[] = "o.status = :status";
                $bindParams[':status'] = $status;
            }

            if ($search) {
                $conditions[] = "(u.fullname LIKE :search OR u.email LIKE :search OR o.id = :order_id)";
                $bindParams[':search'] = "%$search%";
                $bindParams[':order_id'] = (int)$search;
            }

            if (!empty($conditions)) {
                $countQuery .= " AND " . implode(" AND ", $conditions);
            }

            $countStmt = $this->conn->prepare($countQuery);
            foreach ($bindParams as $key => $value) {
                $countStmt->bindValue($key, $value);
            }
            $countStmt->execute();
            $total = $countStmt->fetch(PDO::FETCH_ASSOC)['total'];

            // Query lấy danh sách
            $query = "SELECT o.*, u.fullname as user_name, u.email as user_email,
                             (SELECT COUNT(*) FROM " . $this->order_detail_table . " od WHERE od.order_id = o.id) as total_items
                      FROM " . $this->table_name . " o
                      LEFT JOIN users u ON o.user_id = u.id
                      WHERE 1=1";

            if (!empty($conditions)) {
                $query .= " AND " . implode(" AND ", $conditions);
            }

            $query .= " ORDER BY o.created_at DESC LIMIT :limit OFFSET :offset";

            $stmt = $this->conn->prepare($query);
            foreach ($bindParams as $key => $value) {
                $stmt->bindValue($key, $value);
            }
            $stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
            $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
            $stmt->execute();

            $orders = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Format data
            foreach ($orders as &$order) {
                $order['total'] = (float)$order['total'];
                $order['address'] = json_decode($order['address'], true);
            }

            return [
                'success' => true,
                'data' => [
                    'orders' => $orders,
                    'pagination' => [
                        'current_page' => $page,
                        'per_page' => $limit,
                        'total' => (int)$total,
                        'total_pages' => ceil($total / $limit)
                    ]
                ]
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi lấy danh sách đơn hàng: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Cập nhật trạng thái thanh toán
     */
    public function updatePaymentStatus($orderId, $paymentStatus)
    {
        try {
            // Hỗ trợ cả chữ hoa và chữ thường (tương thích với code mẫu SePay)
            $paymentStatusLower = strtolower($paymentStatus);
            $validStatuses = ['unpaid', 'paid', 'refunded'];
            if (!in_array($paymentStatusLower, $validStatuses)) {
                return [
                    'success' => false,
                    'message' => 'Trạng thái thanh toán không hợp lệ'
                ];
            }
            
            // Sử dụng format lowercase để nhất quán
            $paymentStatus = $paymentStatusLower;

            $query = "UPDATE " . $this->table_name . " SET payment_status = :payment_status, updated_at = NOW() WHERE id = :id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':payment_status', $paymentStatus, PDO::PARAM_STR);
            $stmt->bindParam(':id', $orderId, PDO::PARAM_INT);
            $stmt->execute();

            if ($stmt->rowCount() === 0) {
                return [
                    'success' => false,
                    'message' => 'Không tìm thấy đơn hàng'
                ];
            }

            return [
                'success' => true,
                'message' => 'Cập nhật trạng thái thanh toán thành công'
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Thống kê đơn hàng (Admin)
     */
    public function getStatistics()
    {
        try {
            // Tổng số đơn hàng theo trạng thái
            $statusQuery = "SELECT status, COUNT(*) as count FROM " . $this->table_name . " GROUP BY status";
            $statusStmt = $this->conn->prepare($statusQuery);
            $statusStmt->execute();
            $statusStats = $statusStmt->fetchAll(PDO::FETCH_KEY_PAIR);

            // Tổng doanh thu
            $revenueQuery = "SELECT SUM(total) as total_revenue FROM " . $this->table_name . " WHERE status = 'delivered'";
            $revenueStmt = $this->conn->prepare($revenueQuery);
            $revenueStmt->execute();
            $totalRevenue = $revenueStmt->fetch(PDO::FETCH_ASSOC)['total_revenue'] ?? 0;

            // Doanh thu theo tháng (12 tháng gần nhất)
            $monthlyQuery = "SELECT 
                                DATE_FORMAT(created_at, '%Y-%m') as month,
                                SUM(total) as revenue,
                                COUNT(*) as order_count
                             FROM " . $this->table_name . " 
                             WHERE status = 'delivered' AND created_at >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
                             GROUP BY DATE_FORMAT(created_at, '%Y-%m')
                             ORDER BY month ASC";
            $monthlyStmt = $this->conn->prepare($monthlyQuery);
            $monthlyStmt->execute();
            $monthlyStats = $monthlyStmt->fetchAll(PDO::FETCH_ASSOC);

            return [
                'success' => true,
                'data' => [
                    'status_stats' => $statusStats,
                    'total_revenue' => (float)$totalRevenue,
                    'monthly_stats' => $monthlyStats
                ]
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    // ================== Helper Methods ==================

    /**
     * Lấy thông tin variant
     */
    private function getVariant($variantId)
    {
        $query = "SELECT pv.id, pv.product_id, pv.price, pv.sku, pv.quantity, pv.image, pv.colors, pv.created_at, p.name as product_name 
                  FROM product_variants pv 
                  LEFT JOIN products p ON pv.product_id = p.id 
                  WHERE pv.id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $variantId, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Lấy thông tin phương thức vận chuyển
     */
    private function getShippingMethod($id)
    {
        $query = "SELECT * FROM shipping_method WHERE id = :id AND status = '1'";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Lấy thông tin voucher
     */
    private function getVoucher($id)
    {
        $query = "SELECT * FROM vouchers WHERE id = :id AND status = 1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Kiểm tra voucher hợp lệ
     */
    private function isVoucherValid($voucher, $total)
    {
        $now = date('Y-m-d H:i:s');

        // Kiểm tra ngày hết hạn
        if ($voucher['expired_at'] && $voucher['expired_at'] < $now) {
            return false;
        }

        // Kiểm tra số lượng
        if ($voucher['quantity'] !== null && $voucher['quantity'] <= 0) {
            return false;
        }

        // Kiểm tra giá trị đơn hàng tối thiểu
        if ($voucher['min_order_value'] && $total < $voucher['min_order_value']) {
            return false;
        }

        return true;
    }

    /**
     * Cập nhật tồn kho variant
     */
    private function updateVariantStock($variantId, $quantityChange)
    {
        $query = "UPDATE product_variants SET quantity = quantity + :change WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':change', $quantityChange, PDO::PARAM_INT);
        $stmt->bindParam(':id', $variantId, PDO::PARAM_INT);
        $stmt->execute();
    }

    /**
     * Hoàn lại tồn kho khi hủy đơn hàng
     */
    private function restoreStock($orderId)
    {
        $query = "SELECT variant_id, quantity FROM " . $this->order_detail_table . " WHERE order_id = :order_id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':order_id', $orderId, PDO::PARAM_INT);
        $stmt->execute();

        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
        foreach ($items as $item) {
            $this->updateVariantStock($item['variant_id'], $item['quantity']);
        }
    }

    /**
     * Xóa giỏ hàng của user sau khi đặt hàng
     */
    private function clearUserCart($userId)
    {
        // Lấy cart_id của user
        $cartQuery = "SELECT id FROM carts WHERE user_id = :user_id";
        $cartStmt = $this->conn->prepare($cartQuery);
        $cartStmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
        $cartStmt->execute();
        $cart = $cartStmt->fetch(PDO::FETCH_ASSOC);

        if ($cart) {
            // Xóa cart items
            $deleteQuery = "DELETE FROM cart_items WHERE cart_id = :cart_id";
            $deleteStmt = $this->conn->prepare($deleteQuery);
            $deleteStmt->bindParam(':cart_id', $cart['id'], PDO::PARAM_INT);
            $deleteStmt->execute();
        }
    }
}