#!/bin/bash

DB_NAME=wordpress_test
DB_USER=root
DB_PASS=''
DB_HOST=mysql

# Parse `DB_HOST` for port or socket references.
PARTS=(${DB_HOST//\:/ })
DB_HOSTNAME=${PARTS[0]};
DB_SOCK_OR_PORT=${PARTS[1]};
EXTRA=""

if ! [ -z $DB_HOSTNAME ] ; then
  if [ $(echo $DB_SOCK_OR_PORT | grep -e '^[0-9]\{1,\}$') ]; then
    EXTRA=" --host=$DB_HOSTNAME --port=$DB_SOCK_OR_PORT --protocol=tcp"
  elif ! [ -z $DB_SOCK_OR_PORT ] ; then
    EXTRA=" --socket=$DB_SOCK_OR_PORT"
  elif ! [ -z $DB_HOSTNAME ] ; then
    EXTRA=" --host=$DB_HOSTNAME --protocol=tcp"
  fi
fi

# Create database.
mysql --execute="CREATE DATABASE IF NOT EXISTS $DB_NAME" --user="$DB_USER" --password="$DB_PASS"$EXTRA

# Database ready!
echo "Database is ready"

# Run tests.
exec $@
