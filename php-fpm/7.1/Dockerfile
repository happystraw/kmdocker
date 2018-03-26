FROM php:7.1-fpm

LABEL maintainer FangYutao <fangyutao1993@hotmail.com>

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone

RUN echo 'date.timezone = Asia/Shanghai' > /usr/local/etc/php/conf.d/timezone.ini

# replace 163 mirrors
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
    && ( \
        echo 'deb http://mirrors.163.com/debian/ jessie main non-free contrib' >> /etc/apt/sources.list \
        && echo 'deb http://mirrors.163.com/debian/ jessie-updates main non-free contrib' >> /etc/apt/sources.list \
        && echo 'deb http://mirrors.163.com/debian/ jessie-backports main non-free contrib' >> /etc/apt/sources.list \
        && echo 'deb http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib' >> /etc/apt/sources.list \
    )

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
        libnghttp2-dev \
        libxml2-dev \
    && apt-get clean \
    && apt-get autoremove

# mcrypt pdo_mysql zip bcmath mbstring gd mysqli soap
RUN docker-php-ext-install mcrypt pdo_mysql zip bcmath mbstring mysqli soap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# redis xdebug mongodb
RUN pecl install redis \
    && pecl install xdebug \
    && pecl install mongodb \
    && pecl install seaslog \
    && docker-php-ext-enable redis xdebug mongodb seaslog \
    && pecl clear-cache

# configuration for xdebug
RUN echo 'xdebug.remote_enable = 1                           ;设置 HTTP 参数 XDEBUG_SESSION_START 开启调试' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo ';xdebug.remote_autostart = 1                        ;自动开启调试, 不需设置 XDEBUG_SESSION_START' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_connect_back = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_handler = dbgp' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_port = 9171' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_host = locdev                        ;通过 docker run --add-host locdev:x.x.x.x 方式绑定宿主机的IP(x.x.x.x)' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.idekey = PHPSTORM' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.profiler_enable_trigger = 1                 ;设置 XDEBUG_PROFILE 生成配置文件' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.profiler_output_dir = /tmp' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.profiler_output_name = trace.%H.%R.%p' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# configuration for gateway
RUN  echo 'seaslog.default_basepath = /home/www/log/gateway  ;默认log根目录' >> /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini \
    && echo 'seaslog.default_logger = default                  ;默认logger目录' >> /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini \
    && echo 'seaslog.default_datetime_format = "Y-m-d H:i:s.z"' >> /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini \
    && echo 'seaslog.disting_type = 0                          ;是否以type分文件 1是 0否(默认)' >> /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini \
    && echo 'seaslog.disting_by_hour = 1                       ;是否每小时划分一个文件 1是     0否(默认)' >> /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini \
    && echo 'seaslog.use_buffer = 0                            ;是否启用buffer 1是 0否(默认)' >> /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini \
    && echo 'seaslog.buffer_size = 0                           ;buffer中缓冲数量, 默认0(不使用buffer_size)' >> /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini \
    && echo 'seaslog.level = 8                                 ;记录日志级别 默认0(所有日志)' >> /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini \
    && echo "seaslog.default_template = '{\"request_time\":\"%T\",\"request_id\":\"%Q\",\"project\":\"gateway\",\"model\":\"gateway_inner\",\"more_info\":{\"level\":\"%L\",\"proccessid\":\"%P\",filename\":\"%F\",\"method\":\"%m\",\"hostname\":\"%H\"},\"client_ip\":\"%I\",%M}'" >> /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini

# hiredis
RUN wget https://github.com/redis/hiredis/archive/v0.13.3.tar.gz -O hiredis.tar.gz \
    && mkdir -p hiredis \
    && tar -xf hiredis.tar.gz -C hiredis --strip-components=1 \
    && rm hiredis.tar.gz \
    && ( \
        cd hiredis \
        && make -j$(nproc) \
        && make install \
        && ldconfig \
    ) \
    && rm -r hiredis

# swoole
RUN wget https://github.com/swoole/swoole-src/archive/v2.1.3.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm swoole.tar.gz \
    && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-async-redis --enable-mysqlnd --enable-coroutine --enable-openssl --enable-http2 \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r swoole \
    && docker-php-ext-enable swoole

# composer & cdn for china
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update --clean-backups \
    && composer config -g repo.packagist composer https://packagist.phpcomposer.com

VOLUME /var/www/kmweb

WORKDIR /var/www/kmweb
