# Hướng dẫn tích hợp SePay

## Tổng quan

Đã tích hợp SePay vào backend theo code mẫu từ thư mục `sepay`. Hệ thống sẽ:
1. Tạo QR code thanh toán với nội dung chuyển khoản: `DH{order_id}`
2. Nhận webhook từ SePay và lưu vào bảng `tb_transactions`
3. Tự động tách mã đơn hàng từ nội dung chuyển khoản và cập nhật trạng thái đơn hàng

## Cài đặt Database

Chạy migration SQL để tạo bảng `tb_transactions`:

```sql
-- File: database/migrations/create_tb_transactions.sql
```

Hoặc chạy trực tiếp:

```sql
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
```

## Cấu hình Environment Variables

Thêm các biến môi trường sau vào file `.env` hoặc cấu hình trên server:

```env
# SePay Configuration
SEPAY_API_KEY=your_api_key_here
SEPAY_WEBHOOK_SECRET=your_webhook_secret_here
SEPAY_ACCOUNT=your_bank_account_number
SEPAY_BANK=your_bank_code (VD: MBBank, VCB, TCB, etc.)
SEPAY_RETURN_URL=https://yourwebsite.com/payment/success
SEPAY_CANCEL_URL=https://yourwebsite.com/payment/cancel
```

## API Endpoints

### 1. Tạo thanh toán SePay

**POST** `/api/v1/payments/create`

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Body:**
```json
{
  "order_id": 123
}
```

**Response:**
```json
{
  "message": "Tạo thanh toán thành công",
  "data": {
    "payment_id": 1,
    "order_id": 123,
    "amount": 3500000,
    "qr_code_url": "https://qr.sepay.vn/img?acc=...&bank=...&amount=3500000&des=DH123",
    "payment_url": "https://qr.sepay.vn/img?...",
    "transaction_id": null
  }
}
```

### 2. Webhook nhận thông báo từ SePay

**POST** `/api/v1/payments/webhook`

**Lưu ý:** Endpoint này được SePay gọi tự động khi có giao dịch thanh toán.

**Cấu hình webhook trên SePay:**
- URL: `https://yourwebsite.com/api/v1/payments/webhook`
- Method: POST
- Xem hướng dẫn: https://docs.sepay.vn/tich-hop-webhooks.html

**Webhook sẽ:**
1. Lưu giao dịch vào bảng `tb_transactions`
2. Tách mã đơn hàng từ nội dung chuyển khoản (format: `DH{order_id}`)
3. Kiểm tra đơn hàng có tồn tại và số tiền khớp
4. Cập nhật trạng thái đơn hàng thành `paid`
5. Cập nhật payment record nếu có

### 3. Kiểm tra trạng thái thanh toán

**GET** `/api/v1/payments/status/{order_id}`

**Headers:**
```
Authorization: Bearer {token}
```

**Response:**
```json
{
  "payment_status": "paid",
  "order_status": "pending",
  "payment_method": "sepay",
  "amount": 3500000,
  "created_at": "2025-11-29 10:00:00",
  "transaction_id": null
}
```

## Quy trình thanh toán

1. **User tạo đơn hàng** → Đơn hàng có `payment_status = 'unpaid'`
2. **User gọi API tạo thanh toán** → Nhận QR code với nội dung: `DH{order_id}`
3. **User quét QR và chuyển khoản** → Nội dung chuyển khoản: `DH{order_id}`
4. **SePay gửi webhook** → Backend xử lý:
   - Lưu vào `tb_transactions`
   - Tách `order_id` từ nội dung: `DH123` → `123`
   - Kiểm tra đơn hàng `id=123`, `total={số tiền}`, `payment_status='unpaid'`
   - Cập nhật `payment_status = 'paid'`
5. **Frontend polling** → Gọi API `/api/v1/payments/status/{order_id}` để kiểm tra trạng thái

## Các file đã tạo/cập nhật

### Files mới:
- `app/models/TransactionModel.php` - Model quản lý bảng `tb_transactions`
- `database/migrations/create_tb_transactions.sql` - Migration SQL

### Files đã cập nhật:
- `app/services/SePayService.php`:
  - Cập nhật `handleWebhook()` để xử lý theo logic code mẫu
  - Cập nhật `createPaymentQR()` để tạo nội dung chuyển khoản `DH{order_id}`

- `app/api/controllers/v1/PaymentController.php`:
  - Cập nhật `webhook()` để lưu vào `tb_transactions` và cập nhật đơn hàng
  - Cập nhật `create()` để tạo nội dung chuyển khoản đúng format

## Lưu ý

1. **Format nội dung chuyển khoản:** Phải là `DH{order_id}` (ví dụ: `DH123`)
2. **Trạng thái đơn hàng:** Backend sử dụng `unpaid`/`paid` (lowercase), khác với code mẫu dùng `Unpaid`/`Paid`
3. **Kiểm tra số tiền:** Webhook sẽ kiểm tra số tiền thanh toán phải khớp với tổng đơn hàng
4. **Bảo mật Webhook:**
   - Nếu có `SEPAY_WEBHOOK_SECRET` trong `.env`, hệ thống sẽ xác thực signature
   - Nếu không có `SEPAY_WEBHOOK_SECRET`, hệ thống sẽ bỏ qua xác thực (cho phép test)
   - Để test local, có thể để trống `SEPAY_WEBHOOK_SECRET` hoặc comment dòng này trong `.env`
   - **Lưu ý:** Trong production, nên cấu hình `SEPAY_WEBHOOK_SECRET` để bảo mật

## Testing

### 1. Test Webhook Endpoint

**Cách 1: Sử dụng script test**
```bash
php scripts/test_webhook.php
```

**Cách 2: Sử dụng Postman hoặc cURL**
```bash
curl -X POST http://localhost/backend/api/v1/payments/webhook \
  -H "Content-Type: application/json" \
  -d '{
    "gateway": "MBBank",
    "transactionDate": "2025-11-29T10:00:00Z",
    "accountNumber": "0903252427",
    "subAccount": null,
    "transferType": "in",
    "transferAmount": 3500000,
    "accumulated": 10000000,
    "code": "ABC123",
    "content": "DH21",
    "referenceCode": "REF123",
    "description": "Thanh toan don hang"
  }'
```

**Lưu ý:** Thay `DH21` bằng order_id thực tế của bạn.

### 2. Kiểm tra kết quả

Sau khi test webhook:
1. Kiểm tra log file: `storage/logs/php-errors.log` - sẽ có log "=== WEBHOOK RECEIVED ==="
2. Kiểm tra bảng `tb_transactions` có record mới:
   ```sql
   SELECT * FROM tb_transactions ORDER BY created_at DESC LIMIT 1;
   ```
3. Kiểm tra đơn hàng có `payment_status = 'paid'`:
   ```sql
   SELECT id, payment_status, total FROM orders WHERE id = 21;
   ```

### 3. Cấu hình Webhook trên SePay

**Quan trọng:** Để SePay tự động gửi webhook khi có giao dịch:

1. Đăng nhập vào SePay Dashboard
2. Vào mục **Cài đặt** → **Webhook**
3. Thêm webhook URL: `https://yourdomain.com/api/v1/payments/webhook`
4. Chọn các sự kiện: **Giao dịch thành công**
5. Lưu cấu hình

**Lưu ý:**
- Webhook URL phải là HTTPS (không dùng HTTP cho production)
- Webhook URL phải accessible từ internet (không dùng localhost)
- Nếu dùng localhost để test, có thể dùng ngrok: `ngrok http 80`

### 4. Debug Webhook

Nếu webhook không hoạt động:

1. **Kiểm tra log:**
   ```bash
   tail -f storage/logs/php-errors.log
   ```

2. **Kiểm tra webhook có được gọi không:**
   - Xem log có dòng "=== WEBHOOK RECEIVED ===" không
   - Nếu không có → Webhook chưa được gọi từ SePay

3. **Kiểm tra format data:**
   - Xem log "Raw webhook data" để kiểm tra format
   - Đảm bảo `content` có format `DH{order_id}`

4. **Kiểm tra database:**
   - Xem bảng `tb_transactions` có record mới không
   - Xem đơn hàng có được cập nhật `payment_status = 'paid'` không

