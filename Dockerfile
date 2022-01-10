FROM drupal:9.3.0-php7.4-apache-bullseye

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    vim 

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN { \
    echo 'xdebug.remote_connect_back=0'; \
    echo 'xdebug.remote_autostart=1'; \
    echo 'xdebug.remote_enable=1'; \
    echo 'xdebug.remote_host="host.docker.internal"'; \
    echo 'xdebug.remote_port=9001'; \
    echo 'xdebug.idekey=PHPSTORM'; \
    echo 'memory_limit = 1024M'; \
    echo 'xdebug.remote_log="/tmp/xdebug.log"';\
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN composer require drush/drush \
    && wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.9.3/drush.phar \
    && chmod +x drush.phar \
    && mv drush.phar /usr/local/bin/drush \
    && drush self-update \
    && drush init

RUN composer require kint-php/kint drupal/devel squizlabs/php_codesniffer drupal/coder --dev 

ENV TERM xterm
