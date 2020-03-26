FROM php:7.1-fpm
ARG TIMEZONE

RUN apt-get update && apt-get install -y libmcrypt-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    mysql-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install pdo_mysql mysqli gd \
    && docker-php-ext-enable imagick

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/time$&& printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.i$&& "date"

WORKDIR /var/xenforo
