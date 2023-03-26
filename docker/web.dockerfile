FROM php:8.1.17-fpm

RUN apt-get update -y \
    && apt-get install -y nginx

# PHP_CPPFLAGS are used by the docker-php-ext-* scripts
ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"

RUN docker-php-ext-install pdo_mysql \
    && docker-php-ext-install opcache \
    && apt-get install libicu-dev -y \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && apt-get remove libicu-dev icu-devtools -y \
    && pecl install redis xdebug \
    && docker-php-ext-enable redis xdebug

COPY ../confs/php/opcache.ini /usr/local/etc/php/conf.d/php-opocache.ini
COPY ../confs/php/xdebug.ini /usr/local/etc/php/conf.d/php-xdebug.ini

COPY ../confs/nginx/nginx-site.conf /etc/nginx/sites-enabled/default
COPY --chmod=777 ../confs/entrypoint.sh /etc/entrypoint.sh

WORKDIR /app

EXPOSE 80 443

ENTRYPOINT ["/etc/entrypoint.sh"]