FROM php:8.2-apache

# Enable Apache modules
RUN a2enmod rewrite
RUN a2enmod headers

# Install MySQL extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Force PHP to show errors (CRITICAL)
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php.ini \
    && echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php.ini \
    && echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php.ini

# Set working directory
WORKDIR /var/www/html

# Copy files
COPY . /var/www/html

# Set Apache document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

# Allow .htaccess
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
