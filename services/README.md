# Dockerfile for KM developer

## Install

### Install from Docker Hub

```shell
# path/to/project 替换为[宿主机的项目路径], 如 /home/happystraw/projects/kmweb:/var/www/kmweb
# locdev:your_ip 替换`your_ip`为[宿主机的IP](xdebug.remote_host), 如 locdev:192.168.97.71
# 9071:9000 绑定fpm端口

# php 7.3
docker run --name kmphpfpm73 -d -p 9073:9000 --add-host locdev:your_ip -v path/to/project:/var/www/kmweb happystraw/kmphpfpm:7.3

# php 7.1
docker run --name kmphpfpm71 -d -p 9071:9000 --add-host locdev:your_ip -v path/to/project:/var/www/kmweb happystraw/kmphpfpm:7.1

# php 5.6
docker run --name kmphpfpm56 -d -p 9054:9000 --add-host locdev:your_ip -v path/to/project:/var/www/kmweb happystraw/kmphpfpm:5.6

# php 5.4
docker run --name kmphpfpm54 -d -p 9054:9000 --add-host locdev:your_ip -v path/to/project:/var/www/kmweb happystraw/kmphpfpm:5.4

# swoole
# 说明:
# - php /var/www/kmweb/start.php 启动命令
docker run --name kmswoole -d -p 5200:5200 -v path/to/project:/var/www/kmweb happystraw/kmswoole php /var/www/kmweb/start.php
```

### Install from source

* Clone

  ```shell
  git clone https://github.com/happystraw/kmdocker
  ```

* Build

  ```shell
  # php 7.3
  cd ./php-fpm/7.3
  docker build -t happystraw/kmphpfpm:7.3 .

  # php 7.1
  cd ./php-fpm/7.1
  docker build -t happystraw/kmphpfpm:7.1 .

  # php 5.4
  cd ./php-fpm/5.4
  docker build -t happystraw/kmphpfpm:5.4 .
  ```

* [Run](#install-from-docker-hub)

## Notes

如果使用宿主机的nginx通讯docker容器的php-fpm时, nginx配置需要注意:

```shell
# ...
# 此处`root`是宿主机的项目路径
root /path/to/project

location ~ .php
{
    # ...
    # 此处的`/var/www/kmweb/public/`是docker容器php-fpm中的项目路径, 不是宿主机上的项目路径
    fastcgi_param  SCRIPT_FILENAME  /var/www/kmweb/public/$fastcgi_script_name;
}
```