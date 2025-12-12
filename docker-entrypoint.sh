#!/usr/bin/env bash
set -e

echo "=== Starting container setup ==="
echo "PORT environment variable: ${PORT:-'not set, using 80'}"

# Fix MPM conflict - chỉ giữ mpm_prefork
echo "Step 1: Fix MPM conflict..."
a2dismod -f mpm_event mpm_worker 2>/dev/null || true
rm -rf /etc/apache2/mods-enabled/mpm_event.* 2>/dev/null || true
rm -rf /etc/apache2/mods-enabled/mpm_worker.* 2>/dev/null || true

if [ ! -f /etc/apache2/mods-enabled/mpm_prefork.load ]; then
    a2enmod -f mpm_prefork 2>/dev/null || \
    (ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load && \
     ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf)
fi
echo "MPM: Only mpm_prefork enabled"

# Fix Apache port cho Railway
APP_PORT="${PORT:-8080}"
echo "Step 2: Configure port ${APP_PORT}..."

# Fix ports.conf - replace any Listen 80 (với hoặc không có trailing whitespace)
sed -i "s/Listen 80\b/Listen ${APP_PORT}/g" /etc/apache2/ports.conf

# Fix VirtualHost - thay thế <VirtualHost *:80> thành <VirtualHost *:PORT>
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${APP_PORT}>/g" /etc/apache2/sites-available/000-default.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${APP_PORT}>/g" /etc/apache2/sites-enabled/000-default.conf 2>/dev/null || true

echo "Apache will listen on port ${APP_PORT}"

# Debug: Show config
echo "=== Debug: ports.conf ==="
cat /etc/apache2/ports.conf
echo "=== Debug: VirtualHost ==="
cat /etc/apache2/sites-available/000-default.conf

# Test config
echo "Step 3: Testing Apache config..."
apache2ctl configtest 2>&1 || {
    echo "ERROR: Apache config test failed!"
    exit 1
}

# Test PHP
echo "Step 4: Testing PHP..."
php -v
php -r "echo 'PHP is working\n';"

echo "=== Setup completed - Starting Apache on port ${APP_PORT} ==="

# Chạy CMD (apache2-foreground) thông qua docker-php-entrypoint
exec /usr/local/bin/docker-php-entrypoint "$@"

