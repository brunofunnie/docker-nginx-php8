#!/usr/bin/env bash

# Update XDEBUG config ip after a build phase in the first execution of the container
sed -i "s|REPLACE_IP|$(/sbin/ip route|awk '/default/ { print $3 }')|g" /usr/local/etc/php/conf.d/php-xdebug.ini

service nginx start
php-fpm