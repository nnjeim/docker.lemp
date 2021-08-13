ARG PHP_TAG
ARG TZ
FROM php:${PHP_TAG}-fpm-alpine3.13

# PHP CLI & PHP fpm config
ENV PHP_CONF=/usr/local/etc

COPY ./php/php.ini $PHP_CONF/php/
COPY ./php/overrides.ini $PHP_CONF/php/conf.d/
COPY ./php-fpm/php-fpm.conf $PHP_CONF/php-fpm.d/

# PHP extensions
RUN apk add --update --no-cache \
		$PHPIZE_DEPS \
        openrc \
        curl \
		git \
		bash \
        build-base \
        bzip2-dev \
        freetype-dev \
        libwebp-dev \
        libxpm-dev \
        libmcrypt-dev \
        libxml2-dev \
        pcre-dev \
        zlib-dev \
        autoconf \
        cyrus-sasl-dev \
        libgsasl-dev \
        oniguruma-dev \
        libressl \
        libressl-dev \
        procps \
		libjpeg-turbo-dev \
		libpng-dev \
		libzip-dev \
		libedit-dev \
		icu-dev \
		openssh-client \
		php7-json \
		php7-openssl \
		imagemagick \
		imagemagick-libs \
		imagemagick-dev \
		sqlite \
	&& docker-php-ext-install \
	    bcmath \
	    ctype \
	    iconv \
	    soap \
	    sockets \
	    exif \
        bz2 \
        mysqli \
	    pdo \
	    pdo_mysql \
	    pcntl \
	    session \
	    calendar \
	    fileinfo \
	    readline \
	    tokenizer \
	    opcache \
	    intl \
	    simplexml \
	    xml \
	    zip

RUN docker-php-ext-configure gd --with-jpeg --with-freetype \
	&& docker-php-ext-install gd

RUN printf "\n" | pecl install xdebug \
    && docker-php-ext-enable --ini-name 20-xdebug.ini.deactivated xdebug

RUN printf "\n" | pecl install imagick \
    && docker-php-ext-enable --ini-name 20-imagick.ini imagick

RUN printf "\n" | pecl install pcov \
    && docker-php-ext-enable --ini-name 20-pcov.ini pcov

RUN printf "\n" | pecl install redis \
    && docker-php-ext-enable --ini-name 20-redis.ini redis

# composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& mv composer.phar /usr/bin/composer

# supervisor
RUN apk --no-cache add supervisor
RUN mkdir -p /etc/supervisor.d
COPY ./supervisor.d/supervisord.conf /etc/
COPY ./supervisor.d/conf/*.ini /etc/supervisor.d/
#RUN /usr/bin/supervisord -n -c /etc/supervisord.conf

RUN mkdir -p /run/openrc
RUN touch /run/openrc/softlevel
