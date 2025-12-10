# API Endpoints Guide

## Base URL Format

Tất cả API endpoints phải có format: `/api/v1/{resource}`

**Ví dụ:**
- ✅ Đúng: `POST /api/v1/reviews`
- ✅ Đúng: `GET /api/v1/products`
- ✅ Đúng: `POST /api/v1/payments/create`
- ❌ Sai: `POST /reviews`
- ❌ Sai: `GET /products`

## Reviews API

### 1. Tạo review mới
```
POST {{base_url}}/api/v1/reviews
Headers:
  Authorization: Bearer {token}
  Content-Type: application/json
Body:
{
  "product_id": 1,
  "content": "Sản phẩm rất tốt!",
  "rating": 5
}
```

### 2. Lấy danh sách reviews
```
GET {{base_url}}/api/v1/reviews?product_id=1&page=1&limit=10
```

### 3. Lấy reviews theo product
```
GET {{base_url}}/api/v1/reviews/product/1
```

### 4. Lấy thống kê rating
```
GET {{base_url}}/api/v1/reviews/stats/1
```

### 5. Lấy review của user hiện tại
```
GET {{base_url}}/api/v1/reviews/my-review/1
Headers:
  Authorization: Bearer {token}
```

### 6. Cập nhật review
```
PUT {{base_url}}/api/v1/reviews/1
Headers:
  Authorization: Bearer {token}
  Content-Type: application/json
Body:
{
  "content": "Đã cập nhật đánh giá",
  "rating": 4
}
```

### 7. Xóa review
```
DELETE {{base_url}}/api/v1/reviews/1
Headers:
  Authorization: Bearer {token}
```

## Payments API

### 1. Tạo thanh toán SePay
```
POST {{base_url}}/api/v1/payments/create
Headers:
  Authorization: Bearer {token}
  Content-Type: application/json
Body:
{
  "order_id": 123
}
```

### 2. Webhook SePay (tự động gọi bởi SePay)
```
POST {{base_url}}/api/v1/payments/webhook
```

### 3. Kiểm tra trạng thái thanh toán
```
GET {{base_url}}/api/v1/payments/status/123
Headers:
  Authorization: Bearer {token}
```

## Lưu ý

1. **Tất cả endpoints phải có prefix `/api/v1/`**
2. **Endpoints yêu cầu authentication cần header `Authorization: Bearer {token}`**
3. **Content-Type cho POST/PUT thường là `application/json`**

## Troubleshooting

### Lỗi 400 "Yêu cầu không hợp lệ"
- **Nguyên nhân:** URL thiếu prefix `/api/v1/`
- **Giải pháp:** Đảm bảo URL có format: `{{base_url}}/api/v1/{resource}`

### Lỗi 404 "Endpoint không tồn tại"
- **Nguyên nhân:** Route không được định nghĩa hoặc URL sai
- **Giải pháp:** Kiểm tra lại URL và xem file `app/core/Router.php` để xem routes được định nghĩa

### Lỗi 401 "Unauthorized"
- **Nguyên nhân:** Thiếu token hoặc token không hợp lệ
- **Giải pháp:** Thêm header `Authorization: Bearer {token}` với token hợp lệ

