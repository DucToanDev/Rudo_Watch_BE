#!/usr/bin/env bash
set -e

# Fix MPM conflict - chỉ giữ mpm_prefork (bắt buộc cho PHP)
echo "=== Fixing MPM conflict ==="
a2dismod -f mpm_event mpm_worker 2>/dev/null || true
rm -rf /etc/apache2/mods-enabled/mpm_event.* 2>/dev/null || true
rm -rf /etc/apache2/mods-enabled/mpm_worker.* 2>/dev/null || true

# Đảm bảo mpm_prefork được enable
if [ ! -f /etc/apache2/mods-enabled/mpm_prefork.load ]; then
    a2enmod -f mpm_prefork 2>/dev/null || \
    (ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load && \
     ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf)
fi

# Verify chỉ có 1 MPM
MPM_COUNT=$(ls -1 /etc/apache2/mods-enabled/mpm_*.load 2>/dev/null | wc -l)
if [ "$MPM_COUNT" -ne 1 ]; then
    echo "ERROR: Found $MPM_COUNT MPM modules (should be 1)"
    ls -la /etc/apache2/mods-enabled/mpm_*.load 2>/dev/null || true
    exit 1
fi
echo "SUCCESS: Only mpm_prefork is enabled"
echo "=== MPM fix completed ==="

# Fix Apache port cho Railway (Railway sử dụng PORT env variable)
# https://github.com/docker-library/wordpress/issues/293
sed -i "s/Listen 80/Listen ${PORT:-80}/g" /etc/apache2/ports.conf
echo "Apache will listen on port ${PORT:-80}"

# Gọi entrypoint gốc của PHP Apache image
exec /usr/local/bin/docker-php-entrypoint apache2-foreground

