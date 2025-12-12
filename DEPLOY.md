# Hướng dẫn Deploy lên Hosting

## Cách 1: Deploy vào thư mục con (ví dụ: /backend)

### Bước 1: Upload files
- Upload toàn bộ nội dung trong thư mục `backend/` lên hosting
- Đường dẫn trên hosting: `public_html/backend/` hoặc `www/backend/`

### Bước 2: Cấu hình .htaccess
File `.htaccess` đã được cấu hình sẵn, không cần chỉnh sửa.

### Bước 3: Cài đặt dependencies
```bash
cd backend
composer install --no-dev --optimize-autoloader
```

### Bước 4: Cấu hình Environment Variables
Tạo file `.env` trong thư mục `backend/`:
```env
DB_HOST=your_database_host
DB_PORT=3306
DB_DATABASE=your_database_name
DB_USERNAME=your_database_user
DB_PASSWORD=your_database_password
```

### Bước 5: Set permissions
```bash
chmod -R 755 backend/
chmod -R 775 backend/storage backend/uploads
```

### Bước 6: Test
Truy cập: `https://yourdomain.com/backend/api/v1/products`

---

## Cách 2: Deploy vào root (subdomain hoặc domain riêng)

### Bước 1: Upload files
- Upload toàn bộ nội dung trong thư mục `backend/` lên root của subdomain
- Đường dẫn: `public_html/` hoặc `www/`

### Bước 2: Cấu hình .htaccess
File `.htaccess` đã sẵn sàng, không cần chỉnh.

### Bước 3: Cài đặt dependencies
```bash
composer install --no-dev --optimize-autoloader
```

### Bước 4: Cấu hình Environment Variables
Tạo file `.env`:
```env
DB_HOST=your_database_host
DB_PORT=3306
DB_DATABASE=your_database_name
DB_USERNAME=your_database_user
DB_PASSWORD=your_database_password
```

### Bước 5: Set permissions
```bash
chmod -R 755 .
chmod -R 775 storage uploads
```

### Bước 6: Test
Truy cập: `https://api.yourdomain.com/api/v1/products`

---

## Files/Folders cần upload:

✅ **Cần:**
- `app/` - Source code
- `config/` - Configuration files
- `index.php` - Entry point
- `.htaccess` - Apache configuration
- `composer.json` và `composer.lock`
- `vendor/` - Dependencies (hoặc chạy `composer install` trên server)
- `storage/` - Logs directory
- `uploads/` - Upload directory
- `.env` - Environment variables (tạo mới trên server)

❌ **Không cần:**
- `node_modules/` - Node.js dependencies (không dùng trong PHP backend)
- `Dockerfile`, `docker-entrypoint.sh` - Chỉ dùng cho Docker
- `render.yaml` - Chỉ dùng cho Render
- `.git/` - Git repository
- `*.md` - Documentation files
- `router.php` - Chỉ dùng cho PHP built-in server

---

## Lưu ý quan trọng:

1. **PHP Version**: Cần PHP 8.0 trở lên
2. **Extensions cần thiết**:
   - mysqli / PDO
   - mbstring
   - intl
   - zip
   - curl
   - openssl

3. **Permissions**:
   - `storage/` và `uploads/` cần quyền write (775 hoặc 777)

4. **Database**: Đảm bảo database cho phép kết nối từ IP của hosting

5. **Composer**: Nếu hosting không hỗ trợ Composer CLI, cần upload folder `vendor/` đầy đủ

