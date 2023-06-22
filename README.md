# Docker PHP Environment Boilerplate

## Containers

This web/http container doesn't have SSL enabled

- NGINX
- PHP 8.1.20 (with XDebug 3, Redis)
- MySQL 8.0.30
- Redis 7.0.11 with password
- Mailhog SMTP Mailtrap
- Direnv (see more below)

## Info

The nginx-site.conf file is configured to receive a Laravel Application, so if you want something different like a Wordpress you should modify it to fit your needs.

## XDebug

For using XDebug your IDE must support debugging, this setup was tested with Visual Studio Code.

    ℹ If you're going to use VSCode make sure to install the PHP Debug extension

After installing PHP Debug extension you're pratically good to go, the only step missing is setup the IP for the host machine, for this you can either edit the 'docker/confs/php/php-xdebug.ini' file, or you can install 'direnv' in your host machine and it will be automatically injected by a env variable during the composer up step.

To install 'direnv' (if you use a linux Debian based distro)

```
sudo apt install direnv
```

You must execute the command below on each folder containing a '.envrc' file to enable it to work:

```
direnv allow
```

Also by default XDebug is not enable to start 'on request' for performance reasons, so you'll need to start a session passing a parameter in the URL like one of the below:

```
# To execute just once
http://127.0.0.1:8080/?XDEBUG_SESSION=something

# To start session
http://127.0.0.1:8080/?XDEBUG_SESSION_START=something

# To end session
http://127.0.0.1:8080/?XDEBUG_SESSION_END=something
```

## URLs

Localhost
[http://127.0.0.1:8080](http://127.0.0.1:8080)

PhpMyAdmin
[http://127.0.0.1:8081](http://127.0.0.1:8081)

Mailhog
[http://127.0.0.1:8025](http://127.0.0.1:8025)