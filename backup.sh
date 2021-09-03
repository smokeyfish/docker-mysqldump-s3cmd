#!/bin/bash

set -e
set -o pipefail

if [ "${AWS_PATH}" = "None" ]; then
  echo "[mysqlbackup] AWS_PATH environment variable required."
  exit 1
fi

if [ -z "${MYSQL_USER}" ]; then
  echo "[mysqlbackup] MYSQL_USER environment variable required."
  exit 1
fi

if [ -z "${MYSQL_PASSWORD}" ]; then
  echo "[mysqlbackup] MYSQL_PASSWORD environment variable required."
  exit 1
fi

if [ "${MYSQL_DATABASE}" = "None" ]; then
  echo "[mysqlbackup] MYSQL_DATABASE environment variable required."
  exit 1
fi

if [ -z "${MYSQL_PORT}" ]; then
  echo "[mysqlbackup] MYSQL_PORT environment variable required."
  exit 1
fi

if [ -z "${MYSQL_HOST}" ]; then
  echo "[mysqlbackup] MYSQL_HOST environment variable required."
  exit 1
fi

HOST_PARAMS="-h $MYSQL_HOST --port $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD"

echo "[mysqlbackup] Beginning mysqldump of ${MYSQL_HOST}/${MYSQL_DATABASE}"

mysqldump $HOST_PARAMS $MYSQLDUMP_OPTIONS $MYSQL_DATABASE | gzip | aws s3 cp - s3://$AWS_PATH/$MYSQL_DATABASE-$(date +"%Y%m%d%H%M%S").sql.gz

echo "[mysqlbackup] Finished"

exit 0
