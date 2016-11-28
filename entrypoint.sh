#!/bin/bash

set -e
set -o pipefail

if [ "${AWS_ACCESS_KEY}" = "None" ]; then
  echo "AWS_ACCESS_KEY environment variable required."
  exit 1
fi

if [ "${AWS_SECRET}" = "None" ]; then
  echo "AWS_SECRET environment variable required."
  exit 1
fi

if [ "${AWS_PATH}" = "None" ]; then
  echo "AWS_PATH environment variable required."
  exit 1
fi

if [ -z "${MYSQL_USER}" ]; then
  echo "MYSQL_USER environment variable required."
  exit 1
fi

if [ -z "${MYSQL_PASSWORD}" ]; then
  echo "MYSQL_PASSWORD environment variable required."
  exit 1
fi

if [ "${MYSQL_DATABASE}" = "None" ]; then
  echo "MYSQL_DATABASE environment variable required."
  exit 1
fi

if [ -z "${MYSQL_PORT}" ]; then
  echo "MYSQL_PORT environment variable required."
  exit 1
fi

if [ -z "${MYSQL_HOST}" ]; then
  echo "MYSQL_HOST environment variable required."
  exit 1
fi

HOST_PARAMS="-h $MYSQL_HOST --port $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD"

echo "Beginning mysqldump of ${MYSQL_HOST}/${MYSQL_DATABASE}"

mysqldump $HOST_PARAMS $MYSQLDUMP_OPTIONS $MYSQL_DATABASE | gzip | s3cmd --access_key=$AWS_ACCESS_KEY --secret_key=$AWS_SECRET put - s3://$AWS_PATH/$MYSQL_DATABASE-DEBUGGING-$(date +"%Y%m%d%H%M%S").sql.gz
s3cmd --access_key=$AWS_ACCESS_KEY --secret_key=$AWS_SECRET ls s3://$AWS_PATH/
echo "Finished"

exit 0
