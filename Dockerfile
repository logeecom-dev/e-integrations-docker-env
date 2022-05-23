FROM dockware/essentials:latest

USER root

RUN echo "IncludeOptional /var/www/html/public/*/*/*.conf" >> /etc/apache2/apache2.conf \
    && a2enmod vhost_alias \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

ADD ./templates/apache2/sites.conf /etc/apache2/sites-enabled/000-default.conf