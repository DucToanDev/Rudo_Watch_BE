#!/usr/bin/env bash
set -e

echo "============================================"
echo "🚀 Railway Container Setup"
echo "============================================"

# ============================================
# 1. Fix MPM conflict - chỉ giữ mpm_prefork (cần cho PHP)
# ============================================
echo "📦 Step 1: Configuring Apache MPM..."
a2dismod -f mpm_event mpm_worker 2>/dev/null || true
rm -rf /etc/apache2/mods-enabled/mpm_event.* 2>/dev/null || true
rm -rf /etc/apache2/mods-enabled/mpm_worker.* 2>/dev/null || true

if [ ! -f /etc/apache2/mods-enabled/mpm_prefork.load ]; then
    a2enmod -f mpm_prefork 2>/dev/null || \
    (ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load && \
     ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf)
fi
echo "✅ MPM: Only mpm_prefork enabled"

# ============================================
# 2. Configure Apache port cho Railway
# ============================================
APP_PORT="${PORT:-8080}"
echo "🌐 Step 2: Configuring Apache port ${APP_PORT}..."
echo "   PORT environment variable: ${PORT:-'not set, using default 8080'}"

# Fix ports.conf - replace Listen 80
sed -i "s/Listen 80\b/Listen ${APP_PORT}/g" /etc/apache2/ports.conf

# Fix VirtualHost - replace <VirtualHost *:80>
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${APP_PORT}>/g" /etc/apache2/sites-available/000-default.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${APP_PORT}>/g" /etc/apache2/sites-enabled/000-default.conf 2>/dev/null || true

echo "✅ Apache will listen on port ${APP_PORT}"

# ============================================
# 3. Verify Apache configuration
# ============================================
echo "🔍 Step 3: Testing Apache configuration..."
if apache2ctl configtest 2>&1; then
    echo "✅ Apache configuration is valid"
else
    echo "❌ ERROR: Apache configuration test failed!"
    exit 1
fi

# ============================================
# 4. Verify PHP
# ============================================
echo "🐘 Step 4: Verifying PHP..."
php -v | head -1
php -r "echo '✅ PHP is working\n';"

# ============================================
# 5. Verify Composer dependencies
# ============================================
if [ -f /var/www/html/vendor/autoload.php ]; then
    echo "✅ Composer dependencies installed"
else
    echo "⚠️  Warning: Composer dependencies not found"
fi

# ============================================
# 6. Set permissions (đảm bảo storage writable)
# ============================================
echo "📁 Step 5: Setting permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/uploads 2>/dev/null || true
chmod -R 775 /var/www/html/storage /var/www/html/uploads 2>/dev/null || true

echo "============================================"
echo "✅ Setup completed successfully!"
echo "🚀 Starting Apache on port ${APP_PORT}..."
echo "============================================"

# ============================================
# 7. Execute original entrypoint và CMD
# ============================================
exec /usr/local/bin/docker-php-entrypoint "$@"

