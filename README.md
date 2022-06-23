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
The idea is to separate system and integration in different directories, and to connect them with Linux symlinks. Here is description of that process:
Add your system installation in folder */var/www/html/public/[system-name]/[system-version]* and install your system.
Clone integration to folder */var/www/workspace* and link it to system folder where plugins are stored.

*For example, installing Shopware5 system can be done through browser. Go to [system-version].[system-name].localhost and follow Shopware instructions.
If you want to put some plugin to this system, after cloning integration repository to workspace directory, just run command*
```
ln -s /var/www/workspace/[path-to-integration-src] /var/www/html/public/[system-name]/[system-version]/engine/Shopware/Plugins/Local/Frontend/[integration-name]
```
*and your integration will be available in your system.*

## How to run composer inside container?
If you have multiple SSH keys, you have to specify which of them are you using for running composer (specify the key which is connected to logeecom github):
```
GIT_SSH_COMMAND='ssh -i /root/.ssh/id_rsa_github -o IdentitiesOnly=yes' composer install
```

## How to setup db connection inside PHPSTORM?
Create new MySql database instance in PHPStorm and configure it as on the picture:
![image](https://user-images.githubusercontent.com/88436311/175286964-843a0505-7ae9-42ae-8ba0-28ef42daf05a.png)
with credentials:
```
username: root
password: root
```
After that, go to SSH/SSL tab, check 'Use SSH tunnel' and add SSH connection:
- Click on ... option
- Add new SSH connection
- Configure it as on the picture:
  ![image](https://user-images.githubusercontent.com/88436311/175287940-1b3dc4ab-1c8f-49bf-9293-aa7f10a55a23.png)
  with credentials:
  ```
  username: dockware
  password: dockware
  ```
Test your connection, and if it is successful, you will be able to access database inside docker container.
