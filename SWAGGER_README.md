# Hướng dẫn sử dụng Swagger Documentation

## ✅ File đã được merge hoàn chỉnh!

File `swagger.yaml` đã chứa **TẤT CẢ** các endpoints (62 endpoints) của API backend.

## Cấu trúc file

- `swagger.yaml` - File chính chứa:
  - Thông tin API cơ bản (OpenAPI 3.0.3)
  - Components & Schemas (User, Product, Category, Brand, Cart, Order, Address, Review, Voucher)
  - Security schemes (Bearer Auth)
  - **62 endpoints** đầy đủ:
    - Authentication (register, login, forgot password, social auth)
    - Users (profile, update, change password, admin endpoints)
    - Products (CRUD, featured, latest, by category/brand)
    - Product Variants (CRUD, by product)
    - Categories (CRUD, active)
    - Brands (CRUD, active)
    - Cart (add, update, remove, clear, sync, count)
    - Orders (CRUD, cancel, admin, statistics, status updates)
    - Reviews (CRUD, by product, stats, my review)
    - Addresses (CRUD, default, set default)
    - Vouchers (CRUD, validate, apply, check)
    - Payments (create, webhook, status)
    - Shipping Methods (CRUD, calculate, admin)
    - Posts (CRUD)
    - Post Categories (CRUD, active)
    - Upload (image, images, delete)
    - Home (trang chủ data)

## Xem Swagger UI

Sau khi merge xong, bạn có thể:

1. **Sử dụng Swagger Editor online**: https://editor.swagger.io/
   - Copy toàn bộ nội dung file `swagger.yaml` và paste vào editor

2. **Cài đặt Swagger UI local**:
   ```bash
   npm install -g swagger-ui-serve
   swagger-ui-serve swagger.yaml
   ```

3. **Sử dụng Docker**:
   ```bash
   docker run -p 8080:8080 -e SWAGGER_JSON=/swagger.yaml -v $(pwd):/swagger swaggerapi/swagger-ui
   ```

## Lưu ý

- Tất cả các endpoint đều có base path: `/api/v1`
- Endpoints yêu cầu authentication sẽ có `security: - bearerAuth: []`
- Token được gửi trong header: `Authorization: Bearer {token}`
- Response format luôn là:
  ```json
  {
    "status": "success" | "error",
    "statusCode": 200,
    "data": {...}
  }
  ```

## Các endpoint chính

### Authentication
- `POST /api/v1/register` - Đăng ký
- `POST /api/v1/login` - Đăng nhập
- `POST /api/v1/forgot-password/send-code` - Gửi mã reset password
- `POST /api/v1/forgot-password/reset` - Reset password
- `GET /api/v1/facebook` - Đăng nhập Facebook
- `GET /api/v1/google` - Đăng nhập Google

### Products
- `GET /api/v1/products` - Danh sách sản phẩm
- `GET /api/v1/products/{id}` - Chi tiết sản phẩm
- `POST /api/v1/products` - Tạo sản phẩm
- `PUT /api/v1/products/{id}` - Cập nhật sản phẩm
- `DELETE /api/v1/products/{id}` - Xóa sản phẩm
- `GET /api/v1/products/featured` - Sản phẩm nổi bật
- `GET /api/v1/products/latest` - Sản phẩm mới nhất

### Cart
- `GET /api/v1/cart` - Lấy giỏ hàng
- `POST /api/v1/cart/add` - Thêm vào giỏ hàng
- `PUT /api/v1/cart/update` - Cập nhật giỏ hàng
- `DELETE /api/v1/cart/remove` - Xóa khỏi giỏ hàng
- `DELETE /api/v1/cart/clear` - Xóa toàn bộ giỏ hàng
- `POST /api/v1/cart/sync` - Đồng bộ giỏ hàng
- `GET /api/v1/cart/count` - Số lượng sản phẩm

### Orders
- `GET /api/v1/orders` - Danh sách đơn hàng
- `POST /api/v1/orders` - Tạo đơn hàng
- `GET /api/v1/orders/{id}` - Chi tiết đơn hàng
- `PUT /api/v1/orders/{id}/cancel` - Hủy đơn hàng
- `GET /api/v1/orders/admin` - Tất cả đơn hàng (Admin)
- `GET /api/v1/orders/statistics` - Thống kê (Admin)

### Payments
- `POST /api/v1/payments/create` - Tạo thanh toán
- `POST /api/v1/payments/webhook` - Webhook SePay
- `GET /api/v1/payments/status/{id}` - Trạng thái thanh toán

## Cập nhật

Nếu có thay đổi API, cập nhật file `swagger.yaml` tương ứng.

