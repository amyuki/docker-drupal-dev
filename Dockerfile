FROM drupal:8.6

RUN apt-get update \
    && apt-get install -y git mariadb-client vim wget apt-utils libpng-dev zlib1g-dev libnotify-bin zip \
    && rm -rf /var/lib/apt/lists/*

# install the PHP extensions we need
RUN docker-php-ext-install bcmath gd libmemcached-dev libmemcached11

# install Xdebug, from https://xdebug.org/docs/install
RUN pecl install xdebug \
    && pecl install memcached \
    && docker-php-ext-enable xdebug memcached

RUN { \
    echo 'xdebug.remote_connect_back=true'; \
    echo 'xdebug.remote_autostart=true'; \
    echo 'xdebug.remote_enable=true'; \
    echo 'memory_limit = 1024M'; \
    echo 'xdebug.remote_log="/tmp/xdebug.log"';\
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# install Composer globally
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# install drush, from http://docs.drush.org/en/master/install/,
RUN composer require drush/drush \
    && wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar \
    && chmod +x drush.phar \
    && mv drush.phar /usr/local/bin/drush \
    && drush self-update \
    && drush init

ENV TERM xterm
