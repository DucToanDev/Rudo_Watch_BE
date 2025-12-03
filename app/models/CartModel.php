<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';
require_once __DIR__ . '/../../config/function.php';

class CartModel
{
    private $conn;
    private $table_name = 'carts';
    private $cart_items_table = 'cart_items';
    public $response;

    public function __construct()
    {
        $database = new Database();
        $this->conn = $database->getConnection();
        $this->response = new Response();
    }

    /**
     * Lấy giỏ hàng của user (đã đăng nhập)
     */
    public function getCartByUserId($userId)
    {
        try {
            // Lấy hoặc tạo cart cho user
            $cart = $this->getOrCreateCart($userId);

            // Lấy danh sách items trong cart (JOIN với product_variants và products)
            $query = "SELECT ci.id, ci.variant_id, ci.quantity, ci.price_at_add,
                             pv.product_id, pv.price as variant_price, pv.size, pv.sku, pv.quantity as stock, pv.image as variant_image, pv.colors,
                             p.name as product_name, p.slug as product_slug, p.image as product_image
                      FROM " . $this->cart_items_table . " ci
                      LEFT JOIN product_variants pv ON ci.variant_id = pv.id
                      LEFT JOIN products p ON pv.product_id = p.id
                      WHERE ci.cart_id = :cart_id
                      ORDER BY ci.created_at DESC";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':cart_id', $cart['id'], PDO::PARAM_INT);
            $stmt->execute();

            $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Tính tổng tiền
            $totalAmount = 0;
            $totalItems = 0;
            foreach ($items as &$item) {
                // Sử dụng price_at_add nếu có, không thì dùng variant_price
                $price = $item['price_at_add'] ?? $item['variant_price'];
                $item['price'] = $price;
                $item['subtotal'] = $price * $item['quantity'];
                $totalAmount += $item['subtotal'];
                $totalItems += $item['quantity'];

                // Parse colors JSON nếu có
                if ($item['colors']) {
                    $item['colors'] = json_decode($item['colors'], true);
                }
            }

            return [
                'success' => true,
                'cart' => [
                    'id' => $cart['id'],
                    'user_id' => $userId,
                    'items' => $items,
                    'total_items' => $totalItems,
                    'total_amount' => $totalAmount
                ]
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi lấy giỏ hàng: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Lấy hoặc tạo cart cho user
     */
    private function getOrCreateCart($userId)
    {
        $query = "SELECT * FROM " . $this->table_name . " WHERE user_id = :user_id LIMIT 1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            return $stmt->fetch(PDO::FETCH_ASSOC);
        }

        // Tạo cart mới
        $insertQuery = "INSERT INTO " . $this->table_name . " (user_id, created_at, updated_at) VALUES (:user_id, NOW(), NOW())";
        $insertStmt = $this->conn->prepare($insertQuery);
        $insertStmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
        $insertStmt->execute();

        return [
            'id' => $this->conn->lastInsertId(),
            'user_id' => $userId
        ];
    }

    /**
     * Thêm sản phẩm vào giỏ hàng (đã đăng nhập)
     * Yêu cầu: variant_id (bắt buộc)
     */
    public function addItem($userId, $data)
    {
        try {
            $variantId = $data->variant_id ?? null;
            $quantity = $data->quantity ?? 1;

            if (!$variantId) {
                return [
                    'success' => false,
                    'message' => 'Vui lòng cung cấp variant_id'
                ];
            }

            // Kiểm tra variant tồn tại và lấy thông tin
            $variant = $this->getVariant($variantId);
            if (!$variant) {
                return [
                    'success' => false,
                    'message' => 'Biến thể sản phẩm không tồn tại'
                ];
            }

            // Kiểm tra tồn kho (quantity trong product_variants)
            if ($variant['quantity'] < $quantity) {
                return [
                    'success' => false,
                    'message' => 'Số lượng vượt quá tồn kho (còn ' . $variant['quantity'] . ' sản phẩm)'
                ];
            }

            // Lấy hoặc tạo cart
            $cart = $this->getOrCreateCart($userId);

            // Kiểm tra item đã tồn tại trong cart chưa (theo variant_id)
            $existingItem = $this->getCartItemByVariant($cart['id'], $variantId);

            if ($existingItem) {
                // Cập nhật số lượng
                $newQuantity = $existingItem['quantity'] + $quantity;

                // Kiểm tra tồn kho khi cộng dồn
                if ($variant['quantity'] < $newQuantity) {
                    return [
                        'success' => false,
                        'message' => 'Số lượng vượt quá tồn kho (còn ' . $variant['quantity'] . ' sản phẩm)'
                    ];
                }

                $updateQuery = "UPDATE " . $this->cart_items_table . " 
                               SET quantity = :quantity, updated_at = NOW() 
                               WHERE id = :id";
                $updateStmt = $this->conn->prepare($updateQuery);
                $updateStmt->bindParam(':quantity', $newQuantity, PDO::PARAM_INT);
                $updateStmt->bindParam(':id', $existingItem['id'], PDO::PARAM_INT);
                $updateStmt->execute();

                $message = 'Đã cập nhật số lượng sản phẩm trong giỏ hàng';
            } else {
                // Thêm item mới - lưu price_at_add là giá tại thời điểm thêm
                $insertQuery = "INSERT INTO " . $this->cart_items_table . " 
                               (cart_id, variant_id, quantity, price_at_add, created_at, updated_at) 
                               VALUES (:cart_id, :variant_id, :quantity, :price_at_add, NOW(), NOW())";
                $insertStmt = $this->conn->prepare($insertQuery);
                $insertStmt->bindParam(':cart_id', $cart['id'], PDO::PARAM_INT);
                $insertStmt->bindParam(':variant_id', $variantId, PDO::PARAM_INT);
                $insertStmt->bindParam(':quantity', $quantity, PDO::PARAM_INT);
                $insertStmt->bindParam(':price_at_add', $variant['price']);
                $insertStmt->execute();

                $message = 'Đã thêm sản phẩm vào giỏ hàng';
            }

            // Cập nhật thời gian cart
            $this->updateCartTimestamp($cart['id']);

            return [
                'success' => true,
                'message' => $message,
                'cart' => $this->getCartByUserId($userId)['cart']
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi thêm sản phẩm: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     */
    public function updateItem($userId, $data)
    {
        try {
            $itemId = $data->item_id ?? null;
            $variantId = $data->variant_id ?? null;
            $quantity = $data->quantity ?? null;

            // Có thể dùng item_id hoặc variant_id
            if (!$itemId && !$variantId) {
                return [
                    'success' => false,
                    'message' => 'Vui lòng cung cấp item_id hoặc variant_id'
                ];
            }

            if ($quantity === null) {
                return [
                    'success' => false,
                    'message' => 'Vui lòng cung cấp quantity'
                ];
            }

            // Lấy cart của user
            $cart = $this->getOrCreateCart($userId);

            // Tìm item trong cart
            $item = null;
            if ($itemId) {
                $item = $this->getCartItemById($itemId, $cart['id']);
            } else if ($variantId) {
                $item = $this->getCartItemByVariant($cart['id'], $variantId);
            }

            if (!$item) {
                return [
                    'success' => false,
                    'message' => 'Sản phẩm không tồn tại trong giỏ hàng'
                ];
            }

            if ($quantity <= 0) {
                // Xóa item nếu quantity <= 0
                return $this->removeItem($userId, (object)['item_id' => $item['id']]);
            }

            // Kiểm tra tồn kho
            $variant = $this->getVariant($item['variant_id']);
            if ($variant && $variant['quantity'] < $quantity) {
                return [
                    'success' => false,
                    'message' => 'Số lượng vượt quá tồn kho (còn ' . $variant['quantity'] . ' sản phẩm)'
                ];
            }

            $updateQuery = "UPDATE " . $this->cart_items_table . " 
                           SET quantity = :quantity, updated_at = NOW() 
                           WHERE id = :id";
            $updateStmt = $this->conn->prepare($updateQuery);
            $updateStmt->bindParam(':quantity', $quantity, PDO::PARAM_INT);
            $updateStmt->bindParam(':id', $item['id'], PDO::PARAM_INT);
            $updateStmt->execute();

            $this->updateCartTimestamp($cart['id']);

            return [
                'success' => true,
                'message' => 'Đã cập nhật số lượng',
                'cart' => $this->getCartByUserId($userId)['cart']
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi cập nhật: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Xóa sản phẩm khỏi giỏ hàng
     */
    public function removeItem($userId, $data)
    {
        try {
            $itemId = $data->item_id ?? null;
            $variantId = $data->variant_id ?? null;

            if (!$itemId && !$variantId) {
                return [
                    'success' => false,
                    'message' => 'Vui lòng cung cấp item_id hoặc variant_id'
                ];
            }

            // Lấy cart của user
            $cart = $this->getOrCreateCart($userId);

            // Tìm item trong cart
            $item = null;
            if ($itemId) {
                $item = $this->getCartItemById($itemId, $cart['id']);
            } else if ($variantId) {
                $item = $this->getCartItemByVariant($cart['id'], $variantId);
            }

            if (!$item) {
                return [
                    'success' => false,
                    'message' => 'Sản phẩm không tồn tại trong giỏ hàng'
                ];
            }

            $deleteQuery = "DELETE FROM " . $this->cart_items_table . " WHERE id = :id";
            $deleteStmt = $this->conn->prepare($deleteQuery);
            $deleteStmt->bindParam(':id', $item['id'], PDO::PARAM_INT);
            $deleteStmt->execute();

            $this->updateCartTimestamp($cart['id']);

            return [
                'success' => true,
                'message' => 'Đã xóa sản phẩm khỏi giỏ hàng',
                'cart' => $this->getCartByUserId($userId)['cart']
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi xóa sản phẩm: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Xóa toàn bộ giỏ hàng
     */
    public function clearCart($userId)
    {
        try {
            $cart = $this->getOrCreateCart($userId);

            $deleteQuery = "DELETE FROM " . $this->cart_items_table . " WHERE cart_id = :cart_id";
            $deleteStmt = $this->conn->prepare($deleteQuery);
            $deleteStmt->bindParam(':cart_id', $cart['id'], PDO::PARAM_INT);
            $deleteStmt->execute();

            $this->updateCartTimestamp($cart['id']);

            return [
                'success' => true,
                'message' => 'Đã xóa toàn bộ giỏ hàng'
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi xóa giỏ hàng: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Đồng bộ giỏ hàng từ localStorage khi user đăng nhập
     * LocalStorage items cần có: variant_id, quantity
     */
    public function syncCart($userId, $localItems)
    {
        try {
            if (empty($localItems) || !is_array($localItems)) {
                return $this->getCartByUserId($userId);
            }

            foreach ($localItems as $item) {
                $itemData = (object)[
                    'variant_id' => $item->variant_id ?? $item['variant_id'] ?? null,
                    'quantity' => $item->quantity ?? $item['quantity'] ?? 1
                ];

                if ($itemData->variant_id) {
                    $this->addItem($userId, $itemData);
                }
            }

            return [
                'success' => true,
                'message' => 'Đã đồng bộ giỏ hàng',
                'cart' => $this->getCartByUserId($userId)['cart']
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi khi đồng bộ giỏ hàng: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Lấy thông tin variant (bao gồm cả product info)
     */
    private function getVariant($variantId)
    {
        $query = "SELECT pv.*, p.name as product_name, p.slug as product_slug, p.image as product_image, p.status as product_status
                  FROM product_variants pv
                  LEFT JOIN products p ON pv.product_id = p.id
                  WHERE pv.id = :id LIMIT 1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $variantId, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Lấy cart item theo variant_id
     */
    private function getCartItemByVariant($cartId, $variantId)
    {
        $query = "SELECT * FROM " . $this->cart_items_table . " 
                  WHERE cart_id = :cart_id AND variant_id = :variant_id LIMIT 1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':cart_id', $cartId, PDO::PARAM_INT);
        $stmt->bindParam(':variant_id', $variantId, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Lấy cart item theo ID
     */
    private function getCartItemById($itemId, $cartId)
    {
        $query = "SELECT * FROM " . $this->cart_items_table . " 
                  WHERE id = :id AND cart_id = :cart_id LIMIT 1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $itemId, PDO::PARAM_INT);
        $stmt->bindParam(':cart_id', $cartId, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Cập nhật timestamp của cart
     */
    private function updateCartTimestamp($cartId)
    {
        $query = "UPDATE " . $this->table_name . " SET updated_at = NOW() WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $cartId, PDO::PARAM_INT);
        $stmt->execute();
    }

    /**
     * Lấy số lượng items trong giỏ hàng
     */
    public function getCartCount($userId)
    {
        try {
            $cart = $this->getOrCreateCart($userId);

            $query = "SELECT SUM(quantity) as total FROM " . $this->cart_items_table . " WHERE cart_id = :cart_id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':cart_id', $cart['id'], PDO::PARAM_INT);
            $stmt->execute();
            $result = $stmt->fetch(PDO::FETCH_ASSOC);

            return [
                'success' => true,
                'count' => (int)($result['total'] ?? 0)
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'count' => 0,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }
}