FROM php:5.6-fpm

LABEL maintainer="HappyStraw <fangyutao1993@hotmail.com>"

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

RUN echo 'date.timezone = Asia/Shanghai' > /usr/local/etc/php/conf.d/timezone.ini

RUN apt-get update \
    && apt-get install -y \
        git \
        procps \
        less\
        vim \
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
        libyaml-dev \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# mcrypt pdo_mysql zip bcmath mbstring gd mysqli soap
RUN docker-php-ext-install mcrypt pdo_mysql zip bcmath mbstring mysqli soap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# redis xdebug mongodb
RUN pecl install redis-3.1.6
RUN pecl install xdebug-2.5.5
RUN pecl install mongodb
RUN pecl install seaslog
RUN docker-php-ext-enable redis xdebug mongodb seaslog
RUN pecl clear-cache

# configuration for xdebug
RUN echo 'xdebug.remote_enable = 1                           ;设置 HTTP 参数 XDEBUG_SESSION_START 开启调试' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo ';xdebug.remote_autostart = 1                        ;自动开启调试, 不需设置 XDEBUG_SESSION_START' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_connect_back = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_handler = dbgp' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_port = 9156' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
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

# composer & cdn for china
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update --clean-backups \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

VOLUME /var/www/kmweb

WORKDIR /var/www/kmweb
