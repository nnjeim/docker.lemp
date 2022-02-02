FROM ubuntu:20.04

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y \
    gnupg \
    gosu \
    curl \
    ca-certificates \
    zip \
    unzip \
    git \
    nano \
    supervisor \
    sqlite3 \
    libcap2-bin \
    libpng-dev \
    python2 \
    systemd \
    openssh-server \
    nginx

RUN apt install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get install -y  \
    php8.0-cli  \
    php8.0-fpm \
    php8.0-dev \
    php8.0-sqlite3  \
    php8.0-gd \
    php8.0-curl  \
    php8.0-imap  \
    php8.0-mysql  \
    php8.0-mbstring \
    php8.0-xml  \
    php8.0-zip  \
    php8.0-bcmath  \
    php8.0-soap \
    php8.0-intl  \
    php8.0-readline  \
    php8.0-pcov \
    php8.0-msgpack  \
    php8.0-igbinary  \
    php8.0-ldap \
    php8.0-redis  \
    php8.0-xdebug

RUN setcap "cap_net_bind_service=+ep" /usr/bin/php8.0

# php
ARG OPCACHE
ARG XDEBUG
ENV PHP_CONF=/etc/php/8.0

RUN mkdir -p /run/php/
RUN touch /run/php/php8.0-fpm.pid
RUN touch /run/php/php8.0-fpm.sock

COPY ./php/php.ini $PHP_CONF/cli/
COPY ./php/overrides.ini $PHP_CONF/cli/conf.d/
COPY ./php-fpm/overrides.ini $PHP_CONF/fpm/conf.d/
COPY ./php-fpm/php-fpm.conf $PHP_CONF/fpm/
COPY ./php-fpm/www.conf $PHP_CONF/fpm/pool.d/

RUN if [ "$OPCACHE" = "0" ] ; \
    then mv $PHP_CONF/cli/conf.d/10-opcache.ini $PHP_CONF/cli/conf.d/10-opcache.ini.deactivated ; \
    fi

RUN if [ "$XDEBUG" = "0" ] ; \
    then mv $PHP_CONF/cli/conf.d/20-xdebug.ini $PHP_CONF/cli/conf.d/20-xdebug.ini.deactivated ; \
    fi

# nginx
ENV NGINX_CONF=/etc/nginx
ENV SSL=/etc/ssl

RUN rm -rf $NGINX_CONF/conf.d/default.conf
RUN mkdir -p $NGINX_CONF/sites-enabled
RUN mkdir -p $NGINX_CONF/partials
COPY ./nginx/conf/nginx.conf $NGINX_CONF/nginx.conf
COPY ./nginx/partials/* $NGINX_CONF/partials/
COPY ./nginx/ssl/_wildcard.pem $SSL/certs/_wildcard.pem
COPY ./nginx/ssl/_wildcard-key.pem $SSL/private/_wildcard-key.pem
COPY ./nginx/conf.d/*.conf $NGINX_CONF/conf.d/
COPY ./nginx/sites-available/*.conf $NGINX_CONF/sites-enabled/

# composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& mv composer.phar /usr/bin/composer

# supervisor
COPY ./supervisor/supervisord.conf /etc/supervisor/
COPY ./supervisor/conf.d/*.ini /etc/supervisor/conf.d/

#node
RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs
RUN npm install -g npm

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
