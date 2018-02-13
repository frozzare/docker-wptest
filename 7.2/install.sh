#!/bin/bash

versions_to_install=(
  4.4
  4.4.1
  4.4.2
  4.4.3
  4.4.4
  4.4.5

  4.5
  4.5.1
  4.5.2
  4.5.3
  4.5.4

  4.6
  4.6.1

  4.7
  4.7.1
  4.7.2
  4.7.3
  4.7.4
  4.7.5

  4.8
  4.8.1
  4.8.2
  4.8.3

  4.9
  4.9.1
  4.9.2
  4.9.3
  4.9.4

  latest
)
DB_NAME=wordpress_test
DB_USER=root
DB_PASS=''
DB_HOST=mysql

set -ex

download() {
    if [ `which curl` ]; then
        curl -s "$1" > "$2";
    elif [ `which wget` ]; then
        wget -nv -O "$2" "$1"
    fi
}

prepare() {
  if [[ $WP_VERSION =~ [0-9]+\.[0-9]+(\.[0-9]+)? ]]; then
    WP_TESTS_TAG="tags/$WP_VERSION"
  elif [[ $WP_VERSION == 'nightly' || $WP_VERSION == 'trunk' ]]; then
    WP_TESTS_TAG="trunk"
  else
    # http serves a single offer, whereas https serves multiple. we only want one
    download http://api.wordpress.org/core/version-check/1.7/ /tmp/wp-latest.json
    local LATEST_VERSION=$(grep -o '"version":"[^"]*' /tmp/wp-latest.json | sed 's/"version":"//')
    if [[ -z "$LATEST_VERSION" ]]; then
      echo "Latest WordPress version could not be found"
      exit 1
    fi
    WP_TESTS_TAG="tags/$LATEST_VERSION"
  fi
}

install_wp() {
  if [ -d $WP_CORE_DIR_VERSION ]; then
    return;
  fi

  mkdir -p $WP_CORE_DIR_VERSION

  if [[ $WP_VERSION == 'nightly' || $WP_VERSION == 'trunk' ]]; then
    mkdir -p /tmp/wordpress-nightly
    download https://wordpress.org/nightly-builds/wordpress-latest.zip  /tmp/wordpress-nightly/wordpress-nightly.zip
    unzip -q /tmp/wordpress-nightly/wordpress-nightly.zip -d /tmp/wordpress-nightly/
    mv /tmp/wordpress-nightly/wordpress/* $WP_CORE_DIR_VERSION
  else
    if [ $WP_VERSION == 'latest' ]; then
      local ARCHIVE_NAME='latest'
    else
      local ARCHIVE_NAME="wordpress-$WP_VERSION"
    fi
    download https://wordpress.org/${ARCHIVE_NAME}.tar.gz  /tmp/wordpress.tar.gz
    tar --strip-components=1 -zxmf /tmp/wordpress.tar.gz -C $WP_CORE_DIR_VERSION
  fi

  download https://raw.github.com/markoheijnen/wp-mysqli/master/db.php ${WP_CORE_DIR_VERSION}wp-content/db.php
}

install_test_suite() {
  # portable in-place argument for both GNU sed and Mac OSX sed
  if [[ $(uname -s) == 'Darwin' ]]; then
    local ioption='-i .bak'
  else
    local ioption='-i'
  fi

  # set up testing suite if it doesn't yet exist
  if [ ! -d $WP_TESTS_DIR_VERSION ]; then
    # set up testing suite
    mkdir -p $WP_TESTS_DIR_VERSION
    svn co --quiet https://develop.svn.wordpress.org/${WP_TESTS_TAG}/tests/phpunit/includes/ $WP_TESTS_DIR_VERSION/includes
    svn co --quiet https://develop.svn.wordpress.org/${WP_TESTS_TAG}/tests/phpunit/data/ $WP_TESTS_DIR_VERSION/data
  fi

  cd $WP_TESTS_DIR_VERSION

  if [ ! -f wp-tests-config.php ]; then
    download https://develop.svn.wordpress.org/${WP_TESTS_TAG}/wp-tests-config-sample.php "$WP_TESTS_DIR_VERSION"/wp-tests-config.php
    sed $ioption "s:dirname( __FILE__ ) . '/src/':'$WP_CORE_DIR_VERSION':" "$WP_TESTS_DIR_VERSION"/wp-tests-config.php
    sed $ioption "s/youremptytestdbnamehere/$DB_NAME/" "$WP_TESTS_DIR_VERSION"/wp-tests-config.php
    sed $ioption "s/yourusernamehere/$DB_USER/" "$WP_TESTS_DIR_VERSION"/wp-tests-config.php
    sed $ioption "s/yourpasswordhere/$DB_PASS/" "$WP_TESTS_DIR_VERSION"/wp-tests-config.php
    sed $ioption "s|localhost|${DB_HOST}|" "$WP_TESTS_DIR_VERSION"/wp-tests-config.php
  fi
}

for ver in "${versions_to_install[@]}"; do
	WP_VERSION=$ver
	WP_TESTS_DIR_VERSION=/tmp/wordpress-tests-lib-$ver
	WP_CORE_DIR_VERSION=/tmp/wordpress-$ver/

  prepare
	install_wp
	install_test_suite
done
