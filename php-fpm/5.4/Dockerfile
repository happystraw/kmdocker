FROM php:5.4-fpm

LABEL maintainer FangYutao <fangyutao1993@hotmail.com>

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone

RUN echo 'date.timezone = Asia/Shanghai' > /usr/local/etc/php/conf.d/timezone.ini

RUN apt-get update \
    # && apt-get upgrade -y \
    && apt-get install -y \
        curl \
        wget \
        zip \
        libz-dev \
        libssl-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
    && apt-get clean \
    && apt-get autoremove

# mcrypt pdo_mysql zip bcmath mysqli mbstring gd soap mysql
RUN docker-php-ext-install mcrypt pdo_mysql zip bcmath mysqli mbstring soap mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# redis xdebug
RUN pecl install redis \
    && pecl install xdebug-2.4.1 \
    && docker-php-ext-enable redis xdebug \
    && pecl clear-cache

# configuration for xdebug
RUN echo 'xdebug.remote_enable = 1                           ;设置 HTTP 参数 XDEBUG_SESSION_START 开启调试' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo ';xdebug.remote_autostart = 1                        ;自动开启调试, 不需设置 XDEBUG_SESSION_START' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_connect_back = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_handler = dbgp' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_port = 9154' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_host = locdev                        ;通过 docker run --add-host locdev:x.x.x.x 方式绑定宿主机的IP(x.x.x.x)' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.idekey = PHPSTORM' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.profiler_enable_trigger = 1                 ;设置 XDEBUG_PROFILE 生成配置文件' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.profiler_output_dir = /tmp' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.profiler_output_name = trace.%H.%R.%p' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# seaslog
COPY ./seaslog.tar.gz .

RUN tar -zxf seaslog.tar.gz \
    && rm seaslog.tar.gz \
    && ( \
        cd seaslog \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r seaslog \
    && docker-php-ext-enable seaslog

VOLUME /var/www/kmweb

WORKDIR /var/www/kmweb
