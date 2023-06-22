FROM php:8.1.20-fpm

RUN usermod  --uid 1000 www-data
RUN groupmod --gid 1000 www-data

RUN apt-get update -y \
    && apt-get install -y \
        nginx \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libmagickwand-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j "$(nproc)" bcmath exif gd intl opcache mysqli pdo_mysql zip \
    && pecl install redis xdebug imagick --with-maximum-processors="$(nproc)" \
    && docker-php-ext-enable redis xdebug imagick opcache \
    && apt-get purge -y --auto-remove

COPY ../confs/php/* /usr/local/etc/php/conf.d/
COPY ../confs/nginx/nginx-site.conf /etc/nginx/sites-enabled/default
COPY --chmod=777 ../confs/entrypoint.sh /etc/entrypoint.sh

WORKDIR /app

EXPOSE 80 443

ENTRYPOINT ["/etc/entrypoint.sh"]