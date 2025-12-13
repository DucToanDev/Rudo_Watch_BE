# Hướng dẫn xem Swagger Documentation

## Cách 1: Sử dụng file HTML local (Đơn giản nhất)

1. Mở file `swagger-ui.html` trong trình duyệt
2. File này sẽ tự động load `swagger.yaml` và hiển thị Swagger UI

**Lưu ý**: Cần chạy qua web server (không mở trực tiếp file://)

### Với Laragon/XAMPP:
- Truy cập: `http://localhost/backend/swagger-ui.html`

### Với PHP Built-in Server:
```bash
cd F:\laragon\www\backend
php -S localhost:8000
```
- Truy cập: `http://localhost:8000/swagger-ui.html`

---

## Cách 2: Sử dụng Swagger Editor Online (Không cần setup)

1. Truy cập: https://editor.swagger.io/
2. Click **File** → **Import file**
3. Chọn file `swagger.yaml` của bạn
4. Hoặc copy toàn bộ nội dung `swagger.yaml` và paste vào editor

**Ưu điểm**: 
- Không cần setup gì
- Có thể chia sẻ link
- Có thể export thành các format khác

---

## Cách 3: Deploy lên server (Cho team xem)

### Option A: Sử dụng GitHub Pages

1. Upload `swagger.yaml` và `swagger-ui.html` lên GitHub
2. Enable GitHub Pages trong repository settings
3. Truy cập: `https://yourusername.github.io/repo-name/swagger-ui.html`

### Option B: Deploy lên hosting

1. Upload 2 files lên server:
   - `swagger.yaml`
   - `swagger-ui.html`
2. Truy cập: `https://yourdomain.com/swagger-ui.html`

### Option C: Tích hợp vào API endpoint

Tạo endpoint trong API để serve Swagger UI:

```php
// Thêm vào Router.php hoặc tạo route mới
'/api-docs' => function() {
    header('Content-Type: text/html');
    readfile(__DIR__ . '/swagger-ui.html');
    exit();
}
```

---

## Cách 4: Sử dụng Docker (Nâng cao)

Tạo file `docker-compose.yml`:

```yaml
version: '3.8'
services:
  swagger-ui:
    image: swaggerapi/swagger-ui
    ports:
      - "8080:8080"
    volumes:
      - ./swagger.yaml:/usr/share/nginx/html/swagger.yaml
    environment:
      SWAGGER_JSON: /usr/share/nginx/html/swagger.yaml
```

Chạy:
```bash
docker-compose up
```

Truy cập: `http://localhost:8080`

---

## Cách 5: Sử dụng SwaggerHub (Có tài khoản miễn phí)

1. Đăng ký tại: https://swagger.io/tools/swaggerhub/
2. Tạo API mới
3. Import file `swagger.yaml`
4. Chia sẻ link với team

---

## Khuyến nghị

- **Development local**: Dùng Cách 1 (swagger-ui.html)
- **Chia sẻ nhanh**: Dùng Cách 2 (Swagger Editor online)
- **Production/Team**: Dùng Cách 3 (Deploy lên server)

---

## Troubleshooting

### Lỗi CORS khi load swagger.yaml
- Đảm bảo file `swagger.yaml` và `swagger-ui.html` cùng thư mục
- Hoặc sử dụng Swagger Editor online

### File không hiển thị
- Kiểm tra console browser (F12) để xem lỗi
- Đảm bảo file `swagger.yaml` hợp lệ (đã validate)

### Muốn customize Swagger UI
- Chỉnh sửa file `swagger-ui.html`
- Tham khảo: https://swagger.io/docs/open-source-tools/swagger-ui/usage/configuration/

