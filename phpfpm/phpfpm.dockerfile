FROM php:7.4-fpm

# PHP CLI & PHP fpm config
ENV PHP_INI=/usr/local/etc

COPY ./php/php.ini $PHP_INI/php/
COPY ./php-fpm/php-fpm.conf $PHP_INI/php-fpm.d/

# OS update
RUN apt update
RUN apt install apt-transport-https lsb-release ca-certificates wget -y
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN apt update

# PHP modules
RUN apt install \
    zlib1g-dev \
    libc-dev \
    libzip-dev \
    libpng-dev \
    libedit-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libonig-dev -y

RUN docker-php-ext-install \
    bcmath \
    ctype \
    exif \
    calendar \
    curl \
    fileinfo \
    gd \
    gettext \
    json \
    mbstring \
    opcache \
    pcntl \
    mysqli \
    pdo_mysql \
    readline \
    soap \
    tokenizer \
    zip

# Install PECL and PEAR extensions
RUN pecl install \
    redis \
    xdebug

# Enable PECL and PEAR extensions
RUN docker-php-ext-enable \
    redis

# Install composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
