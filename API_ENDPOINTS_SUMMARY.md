# Tổng hợp API Endpoints - Rudo Watch Ecommerce

## Base URL
```
{{base_url}}/api/v1
```

**Lưu ý:** Tất cả endpoints đều phải có prefix `/api/v1/`

---

## 🔐 Authentication

### Đăng ký
```
POST /api/v1/register
```

### Đăng nhập
```
POST /api/v1/login
```

### Đăng nhập Facebook
```
GET /api/v1/facebook
```

### Đăng nhập Google
```
GET /api/v1/google
```

### Quên mật khẩu - Gửi mã
```
POST /api/v1/forgot-password/send-code
```

### Quên mật khẩu - Reset
```
POST /api/v1/forgot-password/reset
```

---

## 👤 Users

### Lấy thông tin user hiện tại
```
GET /api/v1/user/profile
Headers: Authorization: Bearer {token}
```

### Cập nhật thông tin user
```
PUT /api/v1/user/update
Headers: Authorization: Bearer {token}
```

### Đổi mật khẩu
```
PUT /api/v1/user/change-password
Headers: Authorization: Bearer {token}
```

### Cập nhật role (Admin)
```
PUT /api/v1/user/update-role
Headers: Authorization: Bearer {token}
```

### Lấy danh sách users (Admin)
```
GET /api/v1/users?page=1&limit=10
Headers: Authorization: Bearer {token}
```

---

## 📦 Categories

### Lấy danh sách danh mục
```
GET /api/v1/categories
```

### Lấy danh sách danh mục active
```
GET /api/v1/categories/active
```

### Lấy chi tiết danh mục
```
GET /api/v1/categories/{id}
```

### Tạo danh mục (Admin)
```
POST /api/v1/categories
Headers: Authorization: Bearer {token}
```

### Cập nhật danh mục (Admin)
```
PUT /api/v1/categories/{id}
Headers: Authorization: Bearer {token}
```

### Xóa danh mục (Admin)
```
DELETE /api/v1/categories/{id}?confirm=true
Headers: Authorization: Bearer {token}
```

---

## 🏷️ Brands

### Lấy danh sách thương hiệu
```
GET /api/v1/brands
```

### Lấy danh sách thương hiệu active
```
GET /api/v1/brands/active
```

### Lấy chi tiết thương hiệu
```
GET /api/v1/brands/{id}
```

### Tạo thương hiệu (Admin)
```
POST /api/v1/brands
Headers: Authorization: Bearer {token}
```

### Cập nhật thương hiệu (Admin)
```
PUT /api/v1/brands/{id}
Headers: Authorization: Bearer {token}
```

### Xóa thương hiệu (Admin)
```
DELETE /api/v1/brands/{id}?confirm=true
Headers: Authorization: Bearer {token}
```

---

## 🛍️ Products

### Lấy danh sách sản phẩm
```
GET /api/v1/products?page=1&limit=10&search=&category_id=&brand_id=
```

### Lấy chi tiết sản phẩm
```
GET /api/v1/products/{id}
```

### Sản phẩm nổi bật
```
GET /api/v1/products/featured
```

### Sản phẩm mới nhất
```
GET /api/v1/products/latest
```

### Sản phẩm theo danh mục
```
GET /api/v1/products/category/{category_id}
```

### Sản phẩm theo thương hiệu
```
GET /api/v1/products/brand/{brand_id}
```

### Tạo sản phẩm (Admin)
```
POST /api/v1/products
Headers: Authorization: Bearer {token}
```

### Cập nhật sản phẩm (Admin)
```
PUT /api/v1/products/{id}
Headers: Authorization: Bearer {token}
```

### Xóa sản phẩm (Admin)
```
DELETE /api/v1/products/{id}
Headers: Authorization: Bearer {token}
```

---

## 🎨 Product Variants

### Lấy danh sách variants
```
GET /api/v1/product-variants
```

### Lấy chi tiết variant
```
GET /api/v1/product-variants/{id}
```

### Lấy variants theo product
```
GET /api/v1/product-variants/product/{product_id}
```

---

## 🛒 Cart

### Lấy giỏ hàng
```
GET /api/v1/cart
Headers: Authorization: Bearer {token} (Optional)
```

### Thêm sản phẩm vào giỏ
```
POST /api/v1/cart/add
Headers: Authorization: Bearer {token} (Optional)
Body: { "variant_id": 1, "quantity": 2 }
```

### Cập nhật số lượng
```
PUT /api/v1/cart/update
Headers: Authorization: Bearer {token} (Optional)
Body: { "item_id": 1, "quantity": 3 } hoặc { "variant_id": 1, "quantity": 5 }
```

### Xóa sản phẩm khỏi giỏ
```
DELETE /api/v1/cart/remove
Headers: Authorization: Bearer {token} (Optional)
Body: { "item_id": 1 } hoặc Query: ?variant_id=1
```

### Xóa toàn bộ giỏ hàng
```
DELETE /api/v1/cart/clear
Headers: Authorization: Bearer {token} (Optional)
```

### Đồng bộ giỏ hàng từ localStorage
```
POST /api/v1/cart/sync
Headers: Authorization: Bearer {token}
Body: { "items": [{ "variant_id": 1, "quantity": 2 }] }
```

### Lấy số lượng sản phẩm
```
GET /api/v1/cart/count
Headers: Authorization: Bearer {token} (Optional)
```

---

## 📍 Addresses

### Lấy danh sách địa chỉ
```
GET /api/v1/addresses
Headers: Authorization: Bearer {token}
```

### Lấy địa chỉ mặc định
```
GET /api/v1/addresses/default
Headers: Authorization: Bearer {token}
```

### Lấy chi tiết địa chỉ
```
GET /api/v1/addresses/{id}
Headers: Authorization: Bearer {token}
```

### Tạo địa chỉ mới
```
POST /api/v1/addresses
Headers: Authorization: Bearer {token}
Body: {
  "street": "123 Đường ABC",
  "ward": "Phường 1",
  "province": "TP. Hồ Chí Minh",
  "receiver_name": "Nguyen Van A",
  "receiver_phone": "0912345678",
  "is_default": 1
}
```

### Cập nhật địa chỉ
```
PUT /api/v1/addresses/{id}
Headers: Authorization: Bearer {token}
```

### Đặt làm địa chỉ mặc định
```
PUT /api/v1/addresses/{id}/set-default
Headers: Authorization: Bearer {token}
```

### Xóa địa chỉ
```
DELETE /api/v1/addresses/{id}
Headers: Authorization: Bearer {token}
```

---

## 📦 Orders

### Lấy danh sách đơn hàng (User)
```
GET /api/v1/orders?page=1&limit=10&status=pending
Headers: Authorization: Bearer {token}
```

### Lấy chi tiết đơn hàng (User)
```
GET /api/v1/orders/{id}
Headers: Authorization: Bearer {token}
```

### Tạo đơn hàng mới
```
POST /api/v1/orders
Headers: Authorization: Bearer {token}
Body: {
  "items": [{ "variant_id": 1, "quantity": 2 }],
  "address": { "name": "...", "phone": "...", "province": "...", "district": "...", "ward": "...", "detail": "..." },
  "payment_method": "cod",
  "note": "...",
  "voucher_id": 1,
  "shipping_method_id": 1
}
```

### Hủy đơn hàng (User)
```
PUT /api/v1/orders/{id}/cancel
Headers: Authorization: Bearer {token}
```

### Lấy tất cả đơn hàng (Admin)
```
GET /api/v1/orders/admin?page=1&limit=10&status=pending&search=
Headers: Authorization: Bearer {token}
```

### Cập nhật trạng thái đơn hàng (Admin)
```
PUT /api/v1/orders/{id}/status
Headers: Authorization: Bearer {token}
Body: { "status": "confirmed" }
```

### Cập nhật trạng thái thanh toán (Admin)
```
PUT /api/v1/orders/{id}/payment-status
Headers: Authorization: Bearer {token}
Body: { "payment_status": "paid" }
```

### Thống kê đơn hàng (Admin)
```
GET /api/v1/orders/statistics
Headers: Authorization: Bearer {token}
```

---

## 💳 Payments

### Tạo thanh toán SePay
```
POST /api/v1/payments/create
Headers: Authorization: Bearer {token}
Body: { "order_id": 123 }
```

### Webhook SePay (tự động gọi bởi SePay)
```
POST /api/v1/payments/webhook
```

### Kiểm tra trạng thái thanh toán
```
GET /api/v1/payments/status/{order_id}
Headers: Authorization: Bearer {token}
```

---

## ⭐ Reviews

### Lấy tất cả reviews
```
GET /api/v1/reviews?page=1&limit=10&product_id=&user_id=&rating=&sort_by=created_at&sort_order=DESC
```

### Lấy chi tiết review
```
GET /api/v1/reviews/{id}
```

### Lấy reviews theo Product ID
```
GET /api/v1/reviews/product/{product_id}?page=1&limit=10
```

### Lấy thống kê rating sản phẩm
```
GET /api/v1/reviews/stats/{product_id}
```

### Tạo review mới
```
POST /api/v1/reviews
Headers: Authorization: Bearer {token}
Body: {
  "product_id": 1,
  "content": "Sản phẩm rất tốt!",
  "rating": 5
}
```

### Cập nhật review
```
PUT /api/v1/reviews/{id}
Headers: Authorization: Bearer {token}
Body: {
  "content": "Đã cập nhật đánh giá",
  "rating": 4
}
```

### Xóa review
```
DELETE /api/v1/reviews/{id}
Headers: Authorization: Bearer {token}
```

### Lấy review của tôi cho sản phẩm
```
GET /api/v1/reviews/my-review/{product_id}
Headers: Authorization: Bearer {token}
```

---

## 🚚 Shipping Methods

### Lấy danh sách (Public)
```
GET /api/v1/shipping-methods
```

### Lấy chi tiết
```
GET /api/v1/shipping-methods/{id}
```

### Tính phí vận chuyển
```
POST /api/v1/shipping-methods/calculate
Body: {
  "method_id": 1,
  "order_total": 600000
}
```

### Lấy tất cả (Admin)
```
GET /api/v1/shipping-methods/admin
Headers: Authorization: Bearer {token}
```

### Tạo mới (Admin)
```
POST /api/v1/shipping-methods
Headers: Authorization: Bearer {token}
Body: {
  "name": "Giao hàng hỏa tốc",
  "cost": 100000,
  "status": "1"
}
```

### Cập nhật (Admin)
```
PUT /api/v1/shipping-methods/{id}
Headers: Authorization: Bearer {token}
```

### Xóa (Admin)
```
DELETE /api/v1/shipping-methods/{id}
Headers: Authorization: Bearer {token}
```

---

## 🎫 Vouchers

### Validate voucher
```
POST /api/v1/vouchers/validate
Body: { "code": "SALE10" }
```

### Apply voucher
```
POST /api/v1/vouchers/apply
Body: { "code": "SALE10", "order_total": 1000000 }
```

### Kiểm tra voucher
```
GET /api/v1/vouchers/check/{id}
```

---

## 📝 Posts

### Lấy danh sách bài viết
```
GET /api/v1/posts?category_id=
```

### Lấy chi tiết bài viết
```
GET /api/v1/posts/{id}
```

### Tạo bài viết (Admin)
```
POST /api/v1/posts
Headers: Authorization: Bearer {token}
```

### Cập nhật bài viết (Admin)
```
PUT /api/v1/posts/{id}
Headers: Authorization: Bearer {token}
```

### Xóa bài viết (Admin)
```
DELETE /api/v1/posts/{id}
Headers: Authorization: Bearer {token}
```

---

## 📂 Post Categories

### Lấy danh sách danh mục bài viết
```
GET /api/v1/post-categories
```

### Lấy danh sách danh mục active
```
GET /api/v1/post-categories/active
```

### Lấy chi tiết danh mục
```
GET /api/v1/post-categories/{id}
```

### Tạo danh mục (Admin)
```
POST /api/v1/post-categories
Headers: Authorization: Bearer {token}
```

### Cập nhật danh mục (Admin)
```
PUT /api/v1/post-categories/{id}
Headers: Authorization: Bearer {token}
```

### Xóa danh mục (Admin)
```
DELETE /api/v1/post-categories/{id}
Headers: Authorization: Bearer {token}
```

---

## 🏠 Home

### Lấy dữ liệu trang chủ
```
GET /api/v1/home
Headers: Authorization: Bearer {token} (Optional)
```

---

## 📤 Upload

### Upload ảnh đơn
```
POST /api/v1/upload/image
Headers: Authorization: Bearer {token}
Body: multipart/form-data
  - image: file
  - folder: "products"
```

### Upload nhiều ảnh
```
POST /api/v1/upload/images
Headers: Authorization: Bearer {token}
Body: multipart/form-data
  - images: files[]
  - folder: "products"
```

### Xóa ảnh
```
DELETE /api/v1/upload/{key}
Headers: Authorization: Bearer {token}
```

---

## 📋 Quy tắc chung

1. **Tất cả endpoints phải có prefix `/api/v1/`**
2. **Endpoints yêu cầu authentication cần header:**
   ```
   Authorization: Bearer {token}
   ```
3. **Content-Type cho POST/PUT thường là:**
   ```
   Content-Type: application/json
   ```
4. **Response format:**
   ```json
   {
     "status": "success|error",
     "statusCode": 200|400|401|404|500,
     "data": { ... }
   }
   ```

---

## 🔍 Tìm kiếm và lọc

Hầu hết các endpoint GET hỗ trợ:
- `page`: Số trang (mặc định: 1)
- `limit`: Số item mỗi trang (mặc định: 10)
- `search`: Tìm kiếm (nếu có)
- Các filter khác tùy endpoint

---

## ⚠️ Lưu ý

- **Base URL**: `http://localhost/backend` hoặc domain production
- **Token**: Lấy từ response đăng nhập, lưu vào biến `{{token}}` trong Postman
- **Admin endpoints**: Yêu cầu user có `role = 1`
- **User endpoints**: Chỉ truy cập được dữ liệu của chính user đó (trừ admin)

