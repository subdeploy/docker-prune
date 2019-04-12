#!/bin/sh

STACK_NAME=${STACK_NAME:-docker-prune}

STACK_TEMPLATE='version: "3.6"

configs:
  prune:
      file: ${PRUNE_FILE}
      name: ${PRUNE_CHECKSUM}

services:'

SERVICE_TEMPLATE='
  ${SERVICE}:
    image: docker:18.06
    command: sh prune.sh
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    configs:
      - source: prune
        target: /prune.sh
    environment:
      - FILTER_CONTAINER_UNTIL_HOURS
      - FILTER_NETWORK_UNTIL_HOURS
      - FILTER_IMAGE_UNTIL_HOURS
    deploy:
      replicas: 0
      restart_policy:
        condition: none
      placement:
        constraints:
          - node.labels.hostname==${NODE}'

NODES=$(docker node ls --format "{{.Hostname}}")

STACK_FILE=$STACK_NAME.yml
echo "Generate $STACK_NAME service spec:"
echo "$STACK_TEMPLATE" > $STACK_FILE
for NODE in $NODES ; do
  SERVICE="${NODE%%.*}"
  echo "  $SERVICE"
  echo "$SERVICE_TEMPLATE" | sed -e "s/\${SERVICE}/$SERVICE/g" -e "s/\${NODE}/$NODE/g" >> $STACK_FILE
done

export PRUNE_FILE=prune.sh
export PRUNE_CHECKSUM="${STACK_NAME}_prune.sh_$(sha1sum $PRUNE_FILE | cut -c1-6)"

echo "Deploy $STACK_NAME stack:"
docker stack deploy -c $STACK_FILE $STACK_NAME | sed 's/^/  /'
