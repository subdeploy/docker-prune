#!/bin/sh

echo "Starting docker-prune ($ROLE)"

if [[ $ROLE == "cron" ]] ; then
  CRONTAB_FILE="crontab"
  STACK_NAME=${SERVICE_NAME%%_*}
  JOB_SERVICE="${STACK_NAME}_job"
  CMD="docker service update --force -qd $JOB_SERVICE"
  echo "$CRON_SCHEDULE $CMD" >> $CRONTAB_FILE
  chmod 0644 $CRONTAB_FILE # Grant exec rights
  echo "" >> $CRONTAB_FILE # newline required @EOF
  /usr/bin/crontab $CRONTAB_FILE
  echo "$(cat $CRONTAB_FILE)" | sed 's/^/  /'

  # Run cron and tail logs
  /usr/sbin/crond -f -l 8
fi

if [[ $ROLE == "job" ]] ; then
  export FILTER_CONTAINER_UNTIL_HOURS=${FILTER_CONTAINER_UNTIL_HOURS:-0}
  export FILTER_NETWORK_UNTIL_HOURS=${FILTER_NETWORK_UNTIL_HOURS:-0}
  export FILTER_IMAGE_UNTIL_HOURS=${FILTER_IMAGE_UNTIL_HOURS:-0}
  sh prune.sh
  exit 0
fi