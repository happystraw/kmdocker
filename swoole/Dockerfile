FROM php:7.1

MAINTAINER HappyStraw <fangyutao1993@hotmail.com>

# version
ENV SWOOLE_VERSION 4.2.9

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone

RUN echo 'date.timezone = Asia/Shanghai' > /usr/local/etc/php/conf.d/timezone.ini

RUN apt-get update \
    && apt-get install -y \
        procps \
        less \
        vim \
        curl \
        wget \
        git \
        zip \
        libz-dev \
        libssl-dev \
        libnghttp2-dev \
        libpcre3-dev \
        libmcrypt-dev \
    && apt-get clean \
    && apt-get autoremove

# Composer & Cdn for China
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update --clean-backups \
    && composer config -g repo.packagist composer https://packagist.laravel-china.org

# PDO extension
RUN docker-php-ext-install pdo_mysql

# Mysqli extension
RUN docker-php-ext-install mysqli

# Bcmath extension
RUN docker-php-ext-install bcmath

# Mcrypt extension
RUN docker-php-ext-install mcrypt

# Redis extension
RUN pecl install redis && docker-php-ext-enable redis && pecl clear-cache

# Swoole extension
Run wget https://pecl.php.net/get/swoole-${SWOOLE_VERSION}.tgz -O swoole.tgz \
    && mkdir -p swoole-src \
    && tar -zxvf swoole.tgz -C swoole-src \
    && rm swoole.tgz \
    && ( \
        cd swoole-src/swoole-${SWOOLE_VERSION} \
        && phpize \
        && ./configure --enable-openssl --enable-mysqlnd --enable-http2 \
        && make \
        && make install \
    ) \
    && rm -r swoole-src \
    && docker-php-ext-enable swoole

VOLUME /var/www/kmweb

WORKDIR /var/www/kmweb

# ENTRYPOINT ["php", "/var/www/kmweb/start.php"]
