FROM php:8.4-fpm
ARG TIMEZONE="Europe/Berlin"

RUN apt-get update && apt-get install -y git libmcrypt-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev wget \
    default-mysql-client libmagickwand-dev zip libzip-dev libicu-dev libgmp-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install pdo_mysql mysqli gd zip exif gmp \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone \
    && printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini \
    && "date"

# use php.ini for prod
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"


# Install snuffleupagus
RUN git clone https://github.com/jvoisin/snuffleupagus \
    && cd snuffleupagus/src \
    && phpize \
    && ./configure --enable-module-name --enable-snuffleupagus \
    && make -j "$(nproc)" \
    && make install \
    && cd ../ \
    && docker-php-ext-enable snuffleupagus \
    && mv config/xenforo.rules "$PHP_INI_DIR/conf.d/snuffleupagus.rules" \
    && cd ../ \
    && rm -rf snuffleupagus/

RUN printf "\n\nsp.configuration_file=/usr/local/etc/php/conf.d/snuffleupagus.rules" > $PHP_INI_DIR/php.ini
RUN sed -i -e "s/YOU _DO_ NEED TO CHANGE THIS WITH SOME RANDOM CHARACTERS./$(head -c 256 /dev/urandom | tr -dc 'a-zA-Z0-9')/g" "$PHP_INI_DIR/conf.d/snuffleupagus.rules"

WORKDIR /var/xenforo
