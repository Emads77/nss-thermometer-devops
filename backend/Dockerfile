FROM composer:2.6 AS vendor
WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader

FROM php:8.2-fpm-alpine
RUN apk add --no-cache postgresql-dev zip unzip bash

RUN docker-php-ext-install pdo_pgsql && docker-php-ext-enable pdo_pgsql

WORKDIR /var/www/html

COPY --from=vendor /app/vendor ./vendor
VOLUME ["/var/www/html/vendor"]

COPY . .

RUN chmod -R 755 storage bootstrap/cache && chown -R www-data:www-data storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]

