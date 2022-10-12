FROM dockware/essentials:latest

USER root

#COPY ./templates/apache2/sites.conf /etc/apache2/sites-enabled/000-default.conf

RUN echo "IncludeOptional /var/www/html/public/*/*/*.conf" >> /etc/apache2/apache2.conf \
    && a2enmod vhost_alias \
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
        && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
        && tar vxf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz  -C /usr/local/bin \
        && rm -rf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
        && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
        && echo '<VirtualHost *:80> \n\
                                     ServerAdmin local@dockware \n\
                                     ErrorLog /var/log/apache2/error.log \n\
                                     AccessFileName .htaccess.watch .htaccess \n\
                                     UseCanonicalName Off \n\
                                     VirtualDocumentRoot /var/www/html/public/%2/%1 \n\
                                     <Directory /var/www/html> \n\
                                         Options -Indexes \n\
                                         AllowOverride All \n\
                                         Require all granted \n\
                                         CGIPassAuth On \n\
                                     </Directory> \n\
                                     <FilesMatch \.php$> \n\
                                         # 2.4.10+ can proxy to unix socket \n\
                                         SetHandler "proxy:unix:/var/run/php/php__dockware_php_version__-fpm.sock|fcgi://localhost" \n\
                                     </FilesMatch> \n\
                                 </VirtualHost> \n\
\n\
                                 <VirtualHost *:443> \n\
                                     ErrorLog /var/log/apache2/error.log \n\
                                     AccessFileName .htaccess.watch .htaccess \n\
                                     SSLEngine On \n\
                                     SSLCertificateFile /etc/apache2/ssl/server.crt \n\
                                     SSLCertificateKeyFile /etc/apache2/ssl/server.key \n\
                                     Protocols h2 h2c http/1.1 \n\
                                     UseCanonicalName Off \n\
                                     VirtualDocumentRoot /var/www/html/public/%2/%1 \n\
                                     <FilesMatch \.php$> \n\
                                         # 2.4.10+ can proxy to unix socket \n\
                                         SetHandler "proxy:unix:/var/run/php/php__dockware_php_version__-fpm.sock|fcgi://localhost" \n\
                                     </FilesMatch> \n\
                                     <Directory /var/www/html> \n\
                                         Options -Indexes \n\
                                         AllowOverride All \n\
                                         Require all granted \n\
                                         CGIPassAuth On \n\
                                     </Directory> \n\
                                 </VirtualHost>' > /etc/apache2/sites-enabled/000-default.conf
