FROM php:5.4-fpm

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

# gd
RUN docker-php-ext-install gd

# pdo
RUN docker-php-ext-install pdo_mysql

# mysqli for thinkphp3.2
RUN docker-php-ext-install mysqli

# redis
RUN pecl install redis && docker-php-ext-enable redis && pecl clear-cache

# ADD . /var/www/kmhtgl

# For develop
# VOLUME /var/www/kmhtgl

# WORKDIR /var/www/kmhtgl

# EXPOSE 9000

# CMD ["php-fpm"]



