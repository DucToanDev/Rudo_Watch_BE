#!/bin/bash
set -e

# Railway cung cấp PORT qua environment variable
# Nếu PORT không được set, sử dụng 8080 làm default
PORT=${PORT:-8080}

# Cấu hình Apache để lắng nghe trên PORT
# Thay thế port trong file cấu hình Apache
sed -i "s/Listen 80/Listen ${PORT}/" /etc/apache2/ports.conf 2>/dev/null || true

# Cập nhật virtual host để sử dụng PORT mới
if [ -f /etc/apache2/sites-available/000-default.conf ]; then
    sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/" /etc/apache2/sites-available/000-default.conf 2>/dev/null || true
fi

# Cấu hình Apache để lắng nghe trên PORT (nếu chưa có)
if ! grep -q "Listen ${PORT}" /etc/apache2/ports.conf 2>/dev/null; then
    echo "Listen ${PORT}" >> /etc/apache2/ports.conf
fi

# Chạy command được truyền vào (thường là apache2-foreground)
exec "$@"

