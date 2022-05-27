# E-integrations docker env

[![N|Solid](https://logeecom.com/wp-content/uploads/2016/09/logo-original.png)](https://logeecom.com/)

 _This repository is a [Dockware](https://docs.dockware.io/) fork, customized for faster and easier integration development._

## What are the main differences compared to dockware ?
- https://github.com/nvm-sh/nvm

## How to run a docker environment?
- Create a docker compose file based on the following [template](https://github.com/logeecom-dev/e-integrations-docker-env/blob/main/docker-compose.dist).
 > Note: Elasticsearch is optional and it has been added to the compose file, due to the version of the magenta that requires it.
- Customize [env variables](https://docs.dockware.io/features/environment-variables)
- Create bind mounts
