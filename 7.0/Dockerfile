FROM isotop/php:7-apache

# Environment variables.
ENV WP_VERSION latest

# Install dependencies.
RUN apt-get update && apt-get install -y wget subversion mysql-client

# Copy files.
COPY install.sh /usr/local/bin
COPY run.sh /usr/local/bin

# Install WordPress.
RUN /usr/local/bin/install.sh

# Work in opt directory.
WORKDIR /opt

ENTRYPOINT ["/usr/local/bin/run.sh"]
