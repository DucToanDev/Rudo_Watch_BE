# ============================================
# Dockerfile cho Railway Deployment
# PHP 8.2 + Apache + Composer
# ============================================

# Base image: PHP 8.2 với Apache
FROM php:8.2-apache

# Metadata
LABEL maintainer="Rudo Watch Backend"
LABEL description="Backend API for Rudo Watch E-commerce"

# ============================================
# 1. Cài đặt system dependencies và PHP extensions
# ============================================
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    libicu-dev \
    && docker-php-ext-install -j$(nproc) \
    mysqli \
    pdo \
    pdo_mysql \
    zip \
    intl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ============================================
# 2. Cài đặt Composer
# ============================================
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# ============================================
# 3. Cấu hình Apache
# ============================================
# Bật các modules cần thiết
RUN a2enmod rewrite headers

# Cấu hình Apache để cho phép .htaccess
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Thêm CORS headers vào Apache config
RUN echo '<IfModule mod_headers.c>\n\
    Header always set Access-Control-Allow-Origin "*"\n\
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, PATCH, OPTIONS"\n\
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With, Accept, Origin"\n\
    Header always set Access-Control-Max-Age "86400"\n\
</IfModule>' >> /etc/apache2/conf-available/cors.conf && a2enconf cors

# Fix Apache ServerName warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# ============================================
# 4. Copy entrypoint script
# ============================================
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ============================================
# 5. Setup working directory
# ============================================
WORKDIR /var/www/html

# ============================================
# 6. Copy Composer files và cài đặt dependencies
# (Tối ưu layer caching - chỉ rebuild khi composer files thay đổi)
# ============================================
COPY composer.json composer.lock* ./

# Cài đặt dependencies (production only, no dev dependencies)
RUN if [ -f composer.lock ]; then \
        composer install --no-dev --optimize-autoloader --no-interaction --no-scripts; \
    elif [ -f composer.json ]; then \
        composer install --no-dev --optimize-autoloader --no-interaction --no-scripts; \
    else \
        echo "No composer files found"; \
    fi

# ============================================
# 7. Copy toàn bộ source code
# ============================================
COPY . .

# ============================================
# 8. Chạy composer scripts (nếu có) sau khi copy code
# ============================================
RUN if [ -f composer.json ]; then \
        composer dump-autoload --optimize --classmap-authoritative || true; \
    fi

# ============================================
# 9. Tạo thư mục cần thiết và set permissions
# ============================================
RUN mkdir -p storage/logs uploads/products && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    chmod -R 775 /var/www/html/storage /var/www/html/uploads

# ============================================
# 10. Expose port (Railway sẽ override với PORT env var)
# ============================================
EXPOSE 8080

# ============================================
# 11. Health check (Railway sẽ tự động health check)
# ============================================
# Note: Railway có health check riêng, nhưng có thể dùng để debug
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:${PORT:-8080}/ || exit 1

# ============================================
# 12. Entrypoint và CMD
# ============================================
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
