#!/bin/bash

docker-compose build
docker-compose push
docker stack deploy -c docker-compose.yml docker-prune
