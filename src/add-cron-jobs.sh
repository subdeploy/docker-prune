#!/bin/sh

CRON_TEMPLATE='${MM} ${HH} * * * ${CMD}'

# Create crontab file
CRONTAB_FILE="crontab"
touch CRONTAB_FILE

echo "Add cron jobs:"
NODES=$(docker node ls --format "{{.Hostname}}")
i=0
for NODE in $NODES ; do
  SERVICE=${NODE%%.*}
  SERVICE_NAME="${STACK_NAME}_${SERVICE}"
  CMD="sh $(pwd)/run-prune-service.sh $SERVICE_NAME"
  HH=$PRUNE_HOUR
  MM=$((($i*$NODE_SPACING_MINUTES)%60))
  i=$((i+1))

  # append to crontab file
  echo "$CRON_TEMPLATE" | sed -e "s|\${MM}|$MM|g" -e "s|\${HH}|$HH|g" -e "s|\${CMD}|$CMD|g" >> $CRONTAB_FILE
done

# Grant exec rights
chmod 0644 $CRONTAB_FILE

echo "$(cat $CRONTAB_FILE)" | sed 's/^/  /'
echo "" >> $CRONTAB_FILE # newline required @EOF

# Apply cron job to crontab
/usr/bin/crontab $CRONTAB_FILE