#!/bin/bash

function exec_cmd() {
  CMD=$1
  echo "$CMD"
  echo "$(echo "$CMD" | sh | sed 's/^/  /')"
}

# exec_cmd 'docker system prune -af' # note: running individually to support filtering
exec_cmd 'docker container prune -f --filter "until=${FILTER_CONTAINER_UNTIL_HOURS}h"' # prune stopped containers older than 5d
exec_cmd 'docker network prune -f --filter "until=${FILTER_NETWORK_UNTIL_HOURS}h"' # prune unused networks older than 10d
exec_cmd 'docker image prune -af --filter "until=${FILTER_IMAGE_UNTIL_HOURS}h"' # prune unreferenced images older than 30d

exit 0
