#!/bin/bash

DB_NAME=wordpress_test
DB_USER=root
DB_PASS=''
DB_HOST=mysql
WP_VERSION=${WP_VERSION-latest}
WP_TESTS_DIR_VERSION=/tmp/wordpress-tests-lib-$WP_VERSION
WP_CORE_DIR_VERSION=/tmp/wordpress-$WP_VERSION
WP_TESTS_DIR=/tmp/wordpress-tests-lib
WP_CORE_DIR=/tmp/wordpress

link_test_suite() {
	if [[ -L "$WP_TESTS_DIR" && -d "$WP_TESTS_DIR" ]]; then
		rm -rf $WP_TESTS_DIR
	fi

	if [[ -L "$WP_CORE_DIR" && -d "$WP_CORE_DIR" ]]; then
		rm -rf $WP_CORE_DIR
	fi

	ln -s "$WP_TESTS_DIR_VERSION" "$WP_TESTS_DIR"
	ln -s "$WP_CORE_DIR_VERSION" "$WP_CORE_DIR"
}

install_db() {
	# Parse `DB_HOST` for port or socket references.
	local PARTS=(${DB_HOST//\:/ })
	local DB_HOSTNAME=${PARTS[0]};
	local DB_SOCK_OR_PORT=${PARTS[1]};
	local EXTRA=""

	if ! [ -z $DB_HOSTNAME ] ; then
		if [ $(echo $DB_SOCK_OR_PORT | grep -e '^[0-9]\{1,\}$') ]; then
			EXTRA=" --host=$DB_HOSTNAME --port=$DB_SOCK_OR_PORT --protocol=tcp"
		elif ! [ -z $DB_SOCK_OR_PORT ] ; then
			EXTRA=" --socket=$DB_SOCK_OR_PORT"
		elif ! [ -z $DB_HOSTNAME ] ; then
			EXTRA=" --host=$DB_HOSTNAME --protocol=tcp"
		fi
	fi

	# Create database
	mysql --execute="CREATE DATABASE IF NOT EXISTS $DB_NAME" --user="$DB_USER" --password="$DB_PASS"$EXTRA
}

link_test_suite
install_db

# Database ready!
echo "Test suite is ready"

# Run tests.
exec "$@"
