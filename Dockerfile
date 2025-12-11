# 1. Sử dụng image PHP kèm Apache
FROM php:8.2-apache

# 2. Fix MPM conflict - chỉ enable mpm_prefork (tương thích với PHP)
RUN a2dismod mpm_event mpm_worker 2>/dev/null || true
RUN a2enmod mpm_prefork

# 3. Bật mod_rewrite và mod_headers
RUN a2enmod rewrite headers

# 3. Copy toàn bộ code của bạn vào thư mục web của server
COPY . /var/www/html/

# 4. Cài đặt các extension cơ bản nếu bạn cần kết nối Database (MySQL)
RUN docker-php-ext-install mysqli pdo pdo_mysql

# 5. Cấu hình Apache để cho phép .htaccess và set CORS headers
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# 5.1 Thêm CORS headers vào Apache config
RUN echo '<IfModule mod_headers.c>\n\
    Header always set Access-Control-Allow-Origin "*"\n\
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, PATCH, OPTIONS"\n\
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With, Accept, Origin"\n\
    Header always set Access-Control-Max-Age "86400"\n\
</IfModule>' >> /etc/apache2/conf-available/cors.conf && a2enconf cors

# 5.2 Fix Apache ServerName warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 6. Mở cổng 80 (Render sẽ tự động map cổng này ra ngoài)
EXPOSE 80

# 7. Tạo thư mục logs và cấp quyền
RUN mkdir -p /var/www/html/storage/logs && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    chmod -R 775 /var/www/html/storage