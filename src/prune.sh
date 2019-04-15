#!/bin/bash

function exec_cmd() {
  CMD=$1
  echo "$CMD"
  echo "$(echo "$CMD" | sh | sed 's/^/  /')"
}

function get_filters() {
  ARR_FILTERS=$1
  FILTERS=""
  if [[ ! -z $ARR_FILTERS ]] ; then
    for FILTER in $(echo $ARR_FILTERS | jq -r ".[]") ; do
      FILTERS="$FILTERS --filter \"$FILTER\""
    done
  fi
  echo $FILTERS
}

exec_cmd "docker container prune -f $(get_filters $CONTAINER_FILTERS)"
exec_cmd "docker network prune -f $(get_filters $NETWORK_FILTERS)"
exec_cmd "docker image prune -af $(get_filters $IMAGE_FILTERS)"

# In Global mode, if containers exit too soon then swarm will abort the service update.
NODES=$(docker node ls --format "{{.Hostname}}")
SLEEP=$(($(echo "$NODES" | wc -l)*3))
echo "sleeping $SLEEP seconds before exit to ensure a successful rolling service update."
sleep $SLEEP

exit 0
