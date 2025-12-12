# 1. Sử dụng image PHP kèm Apache (Web server phổ biến nhất)
FROM php:8.2-apache

# 2. Copy entrypoint script để fix MPM conflict và PORT (copy sớm để có thể dùng)
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 3. Bật mod_rewrite và mod_headers cho Apache
RUN a2enmod rewrite headers

# 3.1 Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4. Copy composer files trước để cache dependencies
COPY composer.json composer.lock* /var/www/html/

# 5. Cài đặt dependencies (nếu có composer.lock)
WORKDIR /var/www/html
RUN if [ -f composer.lock ]; then \
        composer install --no-dev --optimize-autoloader --no-interaction; \
    elif [ -f composer.json ]; then \
        composer install --no-dev --optimize-autoloader --no-interaction; \
    fi || echo "No composer.json found or composer install failed"

# 6. Copy toàn bộ code của bạn vào thư mục web của server
COPY . /var/www/html/

# 7. Cài đặt các extension cơ bản nếu bạn cần kết nối Database (MySQL)
RUN docker-php-ext-install mysqli pdo pdo_mysql

# 8. Cấu hình Apache để cho phép .htaccess và set CORS headers
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# 8.1 Thêm CORS headers vào Apache config
RUN echo '<IfModule mod_headers.c>\n\
    Header always set Access-Control-Allow-Origin "*"\n\
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, PATCH, OPTIONS"\n\
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With, Accept, Origin"\n\
    Header always set Access-Control-Max-Age "86400"\n\
</IfModule>' >> /etc/apache2/conf-available/cors.conf && a2enconf cors

# 8.2 Fix Apache ServerName warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 9. Tạo thư mục logs và cấp quyền
RUN mkdir -p /var/www/html/storage/logs && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    chmod -R 775 /var/www/html/storage

# 10. Expose port (Railway uses PORT env variable, but this helps documentation)
EXPOSE 8080

# 11. Set entrypoint để fix MPM conflict và PORT mỗi khi container start
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]