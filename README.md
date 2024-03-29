# E-integrations docker env

[![N|Solid](https://logeecom.com/wp-content/uploads/2016/09/logo-original.png)](https://logeecom.com/)

 _This repository is a [Dockware](https://docs.dockware.io/) fork, customized for faster and easier integration development._

## What are the main differences compared to dockware ?
- [nvm support](https://github.com/nvm-sh/nvm) 
- [mod_vhost_alias support](https://httpd.apache.org/docs/2.4/mod/mod_vhost_alias.html#virtualdocumentroot) - VirtualDocumentRoot is a directive to the Apache module mod_vhost_alias. It sets the document root to a dynamic path that may contain variables which are evaluated when an actual request is handled. That way the effective document root can depend on the actual host name and port number requested, without defining separate virtual hosts for all the combinations. By default apache2 tries to find the webroot in the following format /var/www/html/public/[second part of domain]/[first part of domain]. If the domain for example is 4-4-1.magento2.local, then the web root should be / var/www/html/public/magento2/4-4-1.

## How to run a docker environment?
- Login to logeecom docker registry (You will need a username and password for which you should ask branko.janjic@logeecom.com)
```sh
docker login dreg.devcore.logeecom.com
```
- Create project folder 
```sh
mkdir -p e-integrations && cd e-integrations
```
- Create a docker compose file based on the following [template](https://github.com/logeecom-dev/e-integrations-docker-env/blob/main/docker-compose.dist). 
 > Note: Elasticsearch is optional and it has been added to the compose file, due to the version of the magento that requires it.
 ```sh
curl https://raw.githubusercontent.com/logeecom-dev/e-integrations-docker-env/main/docker-compose.dist?token=GHSAT0AAAAAABW23OWPAX6RY4EFBUOILMO4YW2KWGA -o docker-compose.yml
```
- Customize [env variables](https://docs.dockware.io/features/environment-variables) (optional)
- Create bind mounts (systems and integrations folders) 
```sh
mkdir -p integrations && mkdir -p systems
```
- Run docker compose
 ```sh
docker compose up -d
```
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
## How to setup xdebug with PHPSTORM ?

Add new PHP Remote debug configuration:
- IDE key(session id): PHPSTORM
- Name should be like: [system-version].[system-name].localhost
![debug1](https://user-images.githubusercontent.com/101107199/180241407-05108d2b-514a-4d4a-a110-79c26f43a39c.png)

Server Configuration:
- Name and host should be like *[system-version].[system-name].localhost*
- Check *Use path mappings*
- Map project files:
  - Local path: */[path-to-integrations-directory]/integrations/[path-to-integration-src]*
  - Absolute path on server: */var/www/workspace/[path-to-integration-src]*
- Map include (systems) path (if needed):
  - Local path: */[path-to-systems-directory]/systems/[system-name]/[system-version]*
  - Absolute path on server: */var/www/html/public/[system-name]/[system-version]*
- Click Apply and check if it works.
![debug2](https://user-images.githubusercontent.com/101107199/180241456-73479384-e2d6-46f4-a27a-609d563117f3.png)

## How to create custom project based vhost (if needed for an exotic system or for a custom php project )?
 > Note: The vhost file must end with .conf .

The simplest way is to create a single vhost file within a folder for a specific system or custom project (for example /var/www/html/public/[system-name]/[system-version]/vhost.conf).

## How to run symfony/laravel application (when DocumentRoot is public folder) without custom vhost file? 
These frameworks require that the DocumentRoot folder in the web server configuration be set to a public folder. This can be solved in two ways. A custom virtual host can be created, or a .htaccess file with the following content can be added within the project:
      
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
## How to access docker container via console:
```
docker exec -it logeecom-dev bash
```

## How to switch php version directly from docker container:
- Go to /var/www folder in docker container
```
cd /var/www
```

- Run command:
```
make switch-php version={php-version}
```
