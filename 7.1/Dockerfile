FROM php:7.1-cli

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
&& rm -r /var/lib/apt/lists/* \
&& cp -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/ \
&& docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
&& docker-php-ext-install \
   mcrypt \
   mysqli \
   pdo_dblib \
   pdo_mysql \
   soap \
   zip

# Environment variables.
ENV WP_VERSION latest

# Install dependencies.
RUN apt-get update && apt-get install -y wget subversion mysql-client

# Copy files.
COPY install.sh /usr/local/bin
COPY docker-entrypoint.sh /usr/local/bin

# Install WordPress.
RUN install.sh

# Work in opt directory.
WORKDIR /opt

ENTRYPOINT ["docker-entrypoint.sh"]
