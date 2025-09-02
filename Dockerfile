# ===== STAGE 1: Builder =====
FROM php:8.3-fpm-alpine AS builder
RUN apk add --no-cache bash git unzip curl
# Instala Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader && \
    rm -rf /root/.composer/cache
COPY ./app ./app

# ===== STAGE 2: Produção =====
FROM php:8.3-fpm-alpine
RUN apk add --no-cache bash
WORKDIR /var/www/html
# Copia código e vendor do builder
COPY --from=builder /app /var/www/html
# Config PHP
COPY php/php.ini /usr/local/etc/php/php.ini
# Permissões
RUN chown -R www-data:www-data /var/www/html
EXPOSE 9000
