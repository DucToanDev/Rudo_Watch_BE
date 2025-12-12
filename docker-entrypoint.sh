#!/bin/bash
set -e

# Render/Railway cung cấp PORT qua environment variable
# Nếu PORT không được set, sử dụng 8080 làm default
PORT=${PORT:-8080}

# Cấu hình Apache để lắng nghe trên PORT
# Xóa Listen 80 nếu có
sed -i '/^Listen 80$/d' /etc/apache2/ports.conf 2>/dev/null || true

# Thêm Listen với PORT mới (nếu chưa có)
if ! grep -q "^Listen ${PORT}" /etc/apache2/ports.conf 2>/dev/null; then
    echo "Listen ${PORT}" >> /etc/apache2/ports.conf
fi

# Cập nhật virtual host để sử dụng PORT mới
if [ -f /etc/apache2/sites-available/000-default.conf ]; then
    # Thay thế VirtualHost cũ với port 80
    sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/g" /etc/apache2/sites-available/000-default.conf 2>/dev/null || true
    # Thay thế VirtualHost không có port thành có PORT
    sed -i "s/<VirtualHost \*>/<VirtualHost *:${PORT}>/g" /etc/apache2/sites-available/000-default.conf 2>/dev/null || true
fi

# Export PORT để các process khác có thể sử dụng
export PORT

# Chạy command được truyền vào (thường là apache2-foreground)
exec "$@"

