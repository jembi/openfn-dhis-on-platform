# openfn-dhis-on-platform


## Prerequisites:
1. Docker
1. An Active Docker Swarm

## Getting Started:
1. Check that you have an active docker swarm running on the respective environment. `docker info | grep Swarm`
1. If no swarm is running, you can start a swarm with `docker swarm init`.
1. Run `./get-cli.sh` to download the latest release of the CLI. You can download only the specific CLI for your operating system by providing it as a parameter. (e.g. `./get-cli.sh macos`)
1. Run the relevant deploy script. (e.g. `./deploy-local.sh`)

## Tips:

The `./depoy-{environment}.sh` scripts will default to using the `Linux` binary and running the `init` deploy action. This can be overriden by supplying parameters to the script. The first parameter being the action and the second parameter being the operating system. (e.g. `./deploy-local.sh remove macos` will run the remove command using the MacOS binary)
### Local:
1. The `./deploy-local.sh` script will make use of Platform profiles which are specified to configure the services for local development purposes exposing the ports of these services
### QA:
1. The `./deploy-qa.sh` script will make use of Platform profiles which are specified to configure the services for QA purposes, securing the services