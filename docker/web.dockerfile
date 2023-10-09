FROM php:8.2.9-fpm

ARG WWWGROUP
ARG NODE_VERSION=18

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /app

RUN apt-get update -y \
    && apt-get install -y \
        busybox nginx gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 dnsutils \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libmagickwand-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        libcap2-bin \
        libpng-dev \
    && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && curl -sLS https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /etc/apt/keyrings/yarn.gpg >/dev/null \
    && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y nodejs yarn \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j "$(nproc)" bcmath exif gd intl mysqli opcache pcntl pdo_mysql zip \
    && pecl install imagick pcntl redis swoole xdebug --with-maximum-processors="$(nproc)" \
    && docker-php-ext-enable imagick opcache redis swoole xdebug \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN groupadd --force -g $WWWGROUP raft
RUN useradd -ms /bin/bash --no-user-group -g $WWWGROUP -u 1337 raft

RUN mkdir -p /app /var/cache/nginx /var/log/nginx /etc/nginx/conf.d /var/lib/php
RUN chown -R raft:raft /app && chmod -R 755 /app
RUN chown -R raft:raft /var/cache/nginx
RUN chown -R raft:raft /var/log/nginx
RUN chown -R raft:raft /var/lib/nginx
RUN chown -R raft:raft /etc/nginx/conf.d
RUN touch /var/run/nginx.pid
RUN chown -R raft:raft /var/run/nginx.pid
RUN chown -R raft:raft /var/lib/php

COPY confs/php/ini/* /usr/local/etc/php/conf.d/
COPY confs/php/fpm/* /usr/local/etc/php-fpm.d/
COPY confs/nginx/nginx.conf /etc/nginx/sites-enabled/default
COPY confs/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY --chmod=777 ../confs/entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]