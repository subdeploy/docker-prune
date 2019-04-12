#!/bin/bash

NODES=$(docker node ls --format "{{.Hostname}}")

echo "Add/update hostname labels:"
for NODE in $NODES ; do
  docker node update --label-add "hostname=$NODE" $NODE | sed 's/^/  /'
done
