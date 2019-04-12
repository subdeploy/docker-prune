#!/bin/sh

SERVICE_NAME=$1

# https://docs.docker.com/engine/reference/commandline/service_update/
CMD="docker service update --replicas=1 --force -qd $SERVICE_NAME"
echo $CMD

echo $CMD | sh &>/dev/null
