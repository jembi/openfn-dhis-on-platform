#!/bin/bash

declare ACTION=""
declare COMPOSE_FILE_PATH=""
declare UTILS_PATH=""
declare STACK="openfn-dhis"

function init_vars() {
  ACTION=$1

  COMPOSE_FILE_PATH=$(
    cd "$(dirname "${BASH_SOURCE[0]}")" || exit
    pwd -P
  )

  UTILS_PATH="${COMPOSE_FILE_PATH}/../utils"

  readonly ACTION
  readonly COMPOSE_FILE_PATH
  readonly UTILS_PATH
  readonly STACK
}

# shellcheck disable=SC1091
function import_sources() {
  source "${UTILS_PATH}/docker-utils.sh"
  source "${UTILS_PATH}/config-utils.sh"
  source "${UTILS_PATH}/log.sh"
}

function deploy_importers() {
  # Run through all the config importers
  for service_path in "${COMPOSE_FILE_PATH}/importer/"*/; do
    target_service_name=$(basename "$service_path")

    local swarmfile=${service_path}swarm.sh
    if [[ ! -f $swarmfile ]]; then
      log error "FATAL: $swarmfile is missing, please add it and try again"
      exit 1
    fi
    source $swarmfile

  done
}

function initialize_package() {
  (
    deploy_importers
  ) || {
    log error "Failed to deploy openfn dhis config package"
    exit 1
  }
}

function destroy_package() {
  docker::stack_destroy $STACK

  docker::prune_configs "openfn-dhis"
}

main() {
  init_vars "$@"
  import_sources

  if [[ "${ACTION}" == "init" ]] || [[ "${ACTION}" == "up" ]]; then
    log info "Running package in single node mode"

    initialize_package
  elif [[ "${ACTION}" == "down" ]]; then
    log info "Scaling down package"

    docker::scale_services $STACK 0
  elif [[ "${ACTION}" == "destroy" ]]; then
    log info "Destroying package"

    destroy_package
  else
    log error "Valid options are: init, up, down, or destroy"
  fi
}

main "$@"
