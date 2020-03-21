FROM php:7.3-fpm

LABEL maintainer="HappyStraw <fangyutao1993@hotmail.com>"

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

RUN echo 'date.timezone = Asia/Shanghai' > /usr/local/etc/php/conf.d/timezone.ini

# 切换国内源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
RUN CODE_NAME=$(cat /etc/os-release | grep VERSION_CODENAME= | cut -d= -f2 -) \
    && echo '# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释' > /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ ${CODE_NAME} main contrib non-free" >> /etc/apt/sources.list \
    && echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ ${CODE_NAME} main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ ${CODE_NAME}-updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ ${CODE_NAME}-updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ ${CODE_NAME}-backports main contrib non-free" >> /etc/apt/sources.list \
    && echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ ${CODE_NAME}-backports main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security ${CODE_NAME}/updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security ${CODE_NAME}/updates main contrib non-free" >> /etc/apt/sources.list

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
    libzip-dev \
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

# pdo_mysql zip bcmath mbstring gd mysqli soap
RUN docker-php-ext-install pdo_mysql zip bcmath mbstring mysqli soap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# redis mcrypt xdebug mongodb
RUN pecl install redis
RUN pecl install mcrypt
RUN pecl install xdebug
RUN pecl install mongodb
RUN pecl install seaslog
RUN pecl install yaml
RUN pecl install channel://pecl.php.net/yac-2.0.4
RUN docker-php-ext-enable redis mcrypt xdebug mongodb seaslog yaml yac
RUN pecl clear-cache

# configuration for yaml
RUN echo 'yaml.decode_timestamp=1' >> /usr/local/etc/php/conf.d/docker-php-ext-yaml.ini \
    && echo 'yaml.decode_binary=0' >> /usr/local/etc/php/conf.d/docker-php-ext-yaml.ini \
    && echo 'yaml.decode_php=0' >> /usr/local/etc/php/conf.d/docker-php-ext-yaml.ini

# configuration for yac
RUN echo 'yac.enable_cli = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-yac.ini

# configuration for xdebug
RUN echo 'xdebug.remote_enable = 1                           ;设置 HTTP 参数 XDEBUG_SESSION_START 开启调试' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo ';xdebug.remote_autostart = 1                        ;自动开启调试, 不需设置 XDEBUG_SESSION_START' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_connect_back = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_handler = dbgp' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_port = 9173' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
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
