#!/usr/bin/env bash
set -e

echo "=== Starting container setup ==="

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
echo "Step 2: Configure port ${PORT:-80}..."

# Fix ports.conf
sed -i "s/Listen 80$/Listen ${PORT:-80}/g" /etc/apache2/ports.conf

# Fix VirtualHost - thay thế <VirtualHost *:80> thành <VirtualHost *:PORT>
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT:-80}>/g" /etc/apache2/sites-available/000-default.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT:-80}>/g" /etc/apache2/sites-enabled/000-default.conf 2>/dev/null || true

echo "Apache will listen on port ${PORT:-80}"

# Debug: Show config
echo "ports.conf:"
cat /etc/apache2/ports.conf | grep -i listen
echo "VirtualHost:"
head -5 /etc/apache2/sites-available/000-default.conf

# Test config
echo "Step 3: Testing Apache config..."
apache2ctl configtest 2>&1 || {
    echo "ERROR: Apache config test failed!"
    exit 1
}
echo "=== Setup completed ==="

# Chạy CMD (apache2-foreground) thông qua docker-php-entrypoint
exec /usr/local/bin/docker-php-entrypoint "$@"

