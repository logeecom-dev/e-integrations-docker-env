# E-integrations docker env

[![N|Solid](https://logeecom.com/wp-content/uploads/2016/09/logo-original.png)](https://logeecom.com/)

 _This repository is a [Dockware](https://docs.dockware.io/) fork, customized for faster and easier integration development._

## What are the main differences compared to dockware ?
- [nvm support](https://github.com/nvm-sh/nvm) - By default apache2 tries to find the webroot in the following format / var / www / html / public /[first par domain]/[secon part of domain]. 
- [mod_vhost_alias support](https://httpd.apache.org/docs/2.4/mod/mod_vhost_alias.html#virtualdocumentroot) - VirtualDocumentRoot is a directive to the Apache module mod_vhost_alias. It sets the document root to a dynamic path that may contain variables which are evaluated when an actual request is handled. That way the effective document root can depend on the actual host name and port number requested, without defining separate virtual hosts for all the combinations.

## How to run a docker environment?
- Create a docker compose file based on the following [template](https://github.com/logeecom-dev/e-integrations-docker-env/blob/main/docker-compose.dist).
 > Note: Elasticsearch is optional and it has been added to the compose file, due to the version of the magento that requires it.
- Customize [env variables](https://docs.dockware.io/features/environment-variables)
- Create bind mounts - 
