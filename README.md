# E-integrations docker env

[![N|Solid](https://logeecom.com/wp-content/uploads/2016/09/logo-original.png)](https://logeecom.com/)

 _This repository is a [Dockware](https://docs.dockware.io/) fork, customized for faster and easier integration development._

## What are the main differences compared to dockware ?
- [nvm support](https://github.com/nvm-sh/nvm) 
- [mod_vhost_alias support](https://httpd.apache.org/docs/2.4/mod/mod_vhost_alias.html#virtualdocumentroot) - VirtualDocumentRoot is a directive to the Apache module mod_vhost_alias. It sets the document root to a dynamic path that may contain variables which are evaluated when an actual request is handled. That way the effective document root can depend on the actual host name and port number requested, without defining separate virtual hosts for all the combinations. By default apache2 tries to find the webroot in the following format /var/www/html/public/[second part of domain]/[first part of domain]. If the domain for example is 4-4-1.magento2.local, then the web root should be / var/www/html/public/magento2/4-4-1.

## How to run a docker environment?
- Create a docker compose file based on the following [template](https://github.com/logeecom-dev/e-integrations-docker-env/blob/main/docker-compose.dist).
 > Note: Elasticsearch is optional and it has been added to the compose file, due to the version of the magento that requires it.
- Customize [env variables](https://docs.dockware.io/features/environment-variables)
- Create bind mounts (systems and integrations folders) 
- docker compose up -d 

## How to create custom vhost ?
The simplest way is to create a single vhost file within a folder for a specific system, for example /var/www/html/public/wp/5-9-3/wp.conf.

## How to run symfony/laravel application (when DocumentRoot is public folder)? 
These frameworks require that the DocumentRoot folder in the web server configuration be set to a public folder. This can be solved in two ways. A custom virtual host can be created, or a .htacces file with the following content can be added within the project:
      <IfModule mod_rewrite.c>
      Options +FollowSymLinks
      RewriteEngine On

      RewriteCond %{REQUEST_URI} !^/public/

      RewriteCond %{REQUEST_FILENAME} !-d
      RewriteCond %{REQUEST_FILENAME} !-f



      RewriteRule ^(.*)$ /public/$1
      #RewriteRule ^ index.php [L]
      RewriteRule ^(/)?$ public/index.php [L]
      </IfModule>
## System vs Integration ? 
//TBD
## How to run composer inside container?
//TBD
## How to setup db connection inside PHPSTORM?

