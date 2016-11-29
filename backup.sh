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

if [ -z "${AWS_ACCESS_KEY_ID}" ] || [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
    echo "[mysqlbackup] Not using AWS credentials with s3cmd"
    mysqldump $HOST_PARAMS $MYSQLDUMP_OPTIONS $MYSQL_DATABASE | gzip | s3cmd put - s3://$AWS_PATH/$MYSQL_DATABASE-$(date +"%Y%m%d%H%M%S").sql.gz
else
    echo "[mysqlbackup] Using AWS credentials as parameters for s3cmd"
    mysqldump $HOST_PARAMS $MYSQLDUMP_OPTIONS $MYSQL_DATABASE | gzip | s3cmd --access_key=$AWS_ACCESS_KEY_ID --secret_key=$AWS_SECRET_ACCESS_KEY put - s3://$AWS_PATH/$MYSQL_DATABASE-$(date +"%Y%m%d%H%M%S").sql.gz
fi
echo "[mysqlbackup] Finished"

exit 0
