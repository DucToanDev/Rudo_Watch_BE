# 🚀 Hướng dẫn nhanh xem Swagger

## Cách đơn giản nhất (1 phút)

### Bước 1: Khởi động server
Nếu dùng Laragon/XAMPP, đảm bảo server đang chạy.

### Bước 2: Mở trình duyệt
Truy cập một trong các URL sau:

```
http://localhost/backend/swagger-ui.html
```

hoặc

```
http://localhost/backend/api-docs
```

hoặc

```
http://localhost/backend/swagger
```

hoặc

```
http://localhost/backend/docs
```

### ✅ Xong! Bạn sẽ thấy Swagger UI với đầy đủ API documentation

---

## Chia sẻ cho người khác

### Nếu cùng mạng LAN:
1. Tìm IP máy bạn: `ipconfig` (Windows) hoặc `ifconfig` (Mac/Linux)
2. Chia sẻ URL: `http://YOUR_IP/backend/swagger-ui.html`
3. Người khác truy cập URL đó

### Nếu deploy lên server:
1. Upload 2 files lên server:
   - `swagger.yaml`
   - `swagger-ui.html`
2. Chia sẻ URL: `https://yourdomain.com/swagger-ui.html`

### Nếu muốn chia sẻ online nhanh:
1. Mở https://editor.swagger.io/
2. Click **File** → **Import file**
3. Chọn file `swagger.yaml`
4. Copy link và chia sẻ

---

## Troubleshooting

**Lỗi: File không load được**
- Đảm bảo file `swagger.yaml` và `swagger-ui.html` cùng thư mục
- Kiểm tra console browser (F12) để xem lỗi cụ thể

**Lỗi: CORS**
- Sử dụng Swagger Editor online thay vì local file
- Hoặc đảm bảo chạy qua web server (không mở trực tiếp file://)

**Muốn customize:**
- Chỉnh sửa file `swagger-ui.html`
- Tham khảo: https://swagger.io/docs/open-source-tools/swagger-ui/

