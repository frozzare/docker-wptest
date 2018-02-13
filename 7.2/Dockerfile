FROM php:7.2-cli

# Environment variables.
ENV WP_VERSION latest

# Install dependencies.
RUN apt-get update && apt-get install -y \
   freetds-dev \
   libicu-dev \
   libpq-dev \
   libmcrypt-dev \
   libxml2-dev \
   wget \
   subversion \
   mysql-client \
   zlib1g-dev \
&& rm -r /var/lib/apt/lists/* \
&& cp -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/ \
&& docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
&& docker-php-ext-install \
   mysqli \
   pdo_dblib \
   pdo_mysql \
   soap \
   zip

# Copy files.
COPY install.sh /usr/local/bin
COPY docker-entrypoint.sh /usr/local/bin

# Install WordPress.
RUN install.sh

# Work in opt directory.
WORKDIR /opt

ENTRYPOINT ["docker-entrypoint.sh"]
