#!/bin/sh

CRON_TEMPLATE='${MM} ${HH} * * * ${CMD}'

CRON_JOBS_DIR="$(pwd)/cron_jobs"
mkdir -p $CRON_JOBS_DIR

echo "Add cron jobs:"
NODES=$(docker node ls --format "{{.Hostname}}")
i=0
for NODE in $NODES ; do
  SERVICE=${NODE%%.*}
  SERVICE_NAME="${STACK_NAME}_${SERVICE}"
  CMD="sh $(pwd)/run-prune-service.sh $SERVICE_NAME"
  HH=$PRUNE_HOUR
  MM=$(($i*$NODE_SPACING_MINUTES))

  # Create cron config file
  CRON_JOB_FILE="$CRON_JOBS_DIR/$SERVICE-cron"
  echo "$CRON_TEMPLATE" | sed -e "s|\${CMD}|$CMD|g" -e "s|\${HH}|$HH|g" -e "s|\${MM}|$MM|g" >> $CRON_JOB_FILE
  echo >> $CRON_JOB_FILE # newline required @EOF

  # Grant exec rights
  chmod 0644 $CRON_JOB_FILE

  # Apply cron job to crontab
  echo "$(cat $CRON_JOB_FILE)" | sed 's/^/  /'
  /usr/bin/crontab $CRON_JOB_FILE

  i=$((i+1))
done
