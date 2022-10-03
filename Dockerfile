FROM dockware/essentials:latest

USER root

COPY ./templates/apache2/sites.conf /etc/apache2/sites-enabled/000-default.conf

RUN echo "IncludeOptional /var/www/html/public/*/*/*.conf" >> /etc/apache2/apache2.conf \
    && a2enmod vhost_alias \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && echo "\nxdebug.start_with_request = yes" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
    && echo "\nxdebug.start_with_request = yes" >> /etc/php/8.0/fpm/conf.d/20-xdebug.ini \
    && echo "\nxdebug.start_with_request = yes" >> /etc/php/7.4/fpm/conf.d/20-xdebug.ini \
    && echo "\nxdebug.start_with_request = yes" >> /etc/php/7.4/fpm/conf.d/20-xdebug.ini_disabled \
    && echo "\nxdebug.start_with_request = yes" >> /etc/php/7.3/fpm/conf.d/20-xdebug.ini \
    && echo "xdebug.start_with_request = yes" >> /etc/php/7.2/fpm/conf.d/20-xdebug.ini \
    && sed -i  's/xdebug.remote_autostart = 0//g' /etc/php/7.1/fpm/conf.d/20-xdebug.ini \
    && sed -i  's/xdebug.remote_autostart = 0//g' /etc/php/7.0/fpm/conf.d/20-xdebug.ini \
    && sed -i  's/xdebug.remote_autostart = 0//g' /etc/php/5.6/fpm/conf.d/20-xdebug.ini \
    && echo "\nxdebug.remote_autostart = 1" >> /etc/php/7.1/fpm/conf.d/20-xdebug.ini \
    && echo "\nxdebug.remote_autostart = 1" >> /etc/php/7.0/fpm/conf.d/20-xdebug.ini \
    && echo "\nxdebug.remote_autostart = 1" >> /etc/php/5.6/fpm/conf.d/20-xdebug.ini \
    && apt-get update \
        && apt-get install -y php5.6-mcrypt \
        && apt-get install -y php5.6-sqlite3 \
        && apt-get install -y php7.0-sqlite3 \
        && apt-get install -y php7.1-sqlite3 \
        && apt-get install -y php7.2-sqlite3 \
        && apt-get install -y php7.3-sqlite3 \
        && apt-get install -y php7.4-sqlite3 \
        && apt-get install -y php8.0-sqlite3 \
        && apt-get install -y php8.1-sqlite3 \
        && apt-get remove -y dh-php \
        && rm -rf /var/lib/apt/lists/* /var/cache/apt/*