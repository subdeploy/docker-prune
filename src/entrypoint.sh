#!/bin/sh

export STACK_NAME=${STACK_NAME:-"docker-prune"}
export PRUNE_HOUR=${PRUNE_HOUR:-7}
export NODE_SPACING_MINUTES=${NODE_SPACING_MINUTES:-0}
export FILTER_CONTAINER_UNTIL_HOURS=${FILTER_CONTAINER_UNTIL_HOURS:-0}
export FILTER_NETWORK_UNTIL_HOURS=${FILTER_NETWORK_UNTIL_HOURS:-0}
export FILTER_IMAGE_UNTIL_HOURS=${FILTER_IMAGE_UNTIL_HOURS:-0}

sh add-hostname-labels.sh
sh deploy-prune-stack.sh
sh add-cron-jobs.sh

echo
echo "Setup complete!"
echo

# Run cron and tail logs
/usr/sbin/crond -f -l 8
