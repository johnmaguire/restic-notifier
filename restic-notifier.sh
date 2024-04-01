#!/bin/bash

set -euo pipefail

DIR="$(dirname "$(readlink -f "$0")")"

# FIFO pipe file
QUEUE="${DIR}/.cache/queue"

test -d "${DIR}/.cache" || mkdir -p "${DIR}/.cache"
test -e "${QUEUE}"      || mkfifo "${QUEUE}"

# Pushover credentials
if [[ ! -f "${DIR}/pushover.env" ]]; then
  echo "Create a pushover.env file in ${DIR} that defines USER_KEY and APP_TOKEN"
  exit 1
fi

source "${DIR}/pushover.env"

# Read FIFO file and send notifications
while [[ -e "${QUEUE}" ]]; do
  while read line; do
    curl --silent \
      --connect-timeout 30 \
      --retry 300 \
      --retry-delay 60 \
      --form-string "token=${APP_TOKEN}" \
      --form-string "user=${USER_KEY}" \
      --form-string "title=Backup on $(hostname)" \
      --form-string "message=${line}" \
      https://api.pushover.net/1/messages.json
    sleep 10
  done < $QUEUE
done
