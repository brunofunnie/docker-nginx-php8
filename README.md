# Docker PHP Environment Boilerplate

## Containers

This web/http container doesn't have SSL enabled

- NGINX
- PHP 8.1.17 (with XDebug 3, Redis)
- MySQL 8.0.30
- RabbitMQ 3.9.20 with Management Panel enabled
- Mailhog SMTP Mailtrap
- Direnv (see more below)

## Info

The nginx-site.conf file is configured to receive a Laravel Application, so if you want something different like a Wordpress or another framework, modified it for your needs.

## XDebug

For using XDebug your must support debugging, this setup was tested with Visual Studio Code.

    ℹ If you're going to use VSCode make sure to install the PHP Debug extension

After installing PHP Debug extension you're pratically good to go, the IP for the XDebug it configured automatically after the first build and execution. But if you want to pass your HOST ip address to the XDebug 'client_host' parameter we already have a solution prepared. You just need to install 'direnv' package on linux/mac, type 'direnv allow' inside this project directory and that's it.

## URLs

Localhost
[http://127.0.0.1:8080](http://127.0.0.1:8080)

PhpMyAdmin
[http://127.0.0.1:8081](http://127.0.0.1:8081)

RabbitMQ Management Panel
[http://127.0.0.1:15672](http://127.0.0.1:15672)

Mailhog
[http://127.0.0.1:8025](http://127.0.0.1:8025)