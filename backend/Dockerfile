# Stage 1: Composer dependencies
FROM composer:2.6 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --optimize-autoloader

# Stage 2: PHP 8.2 with PostgreSQL
FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    postgresql-dev \
    zip \
    unzip \
    curl \
    bash

# Set working directory
WORKDIR /var/www/html

# Copy vendor from build stage
COPY --from=vendor /app/vendor ./vendor

# Copy Laravel app
COPY . .

# Permissions
RUN chmod -R 755 storage bootstrap/cache && \
    chown -R www-data:www-data storage bootstrap/cache

# Expose FPM port
EXPOSE 9000

# Start FPM
CMD ["php-fpm"]
