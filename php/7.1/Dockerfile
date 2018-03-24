FROM php:7.1-fpm

LABEL maintainer FangYutao <fangyutao@star-net.cn>

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        curl \
        wget \
        git \
        zip \
        libz-dev \
        libssl-dev \
        libpng++-dev \
        libnghttp2-dev \
    && apt-get clean \
    && apt-get autoremove

# composer & cdn for china
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update --clean-backups \
    && composer config -g repo.packagist composer https://packagist.phpcomposer.com

# gd
RUN docker-php-ext-install gd

# pdo
RUN docker-php-ext-install pdo_mysql

# redis
RUN pecl install redis && docker-php-ext-enable redis && pecl clear-cache

# ADD . /var/www/kmrainbow

# For develop
VOLUME /var/www/kmrainbow

WORKDIR /var/www/kmrainbow

# EXPOSE 9000

# CMD ["php-fpm"]



