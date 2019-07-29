# PHP Docker Setup

> 开箱即用的PHP研发环境搭建

## Projects configuration

1. 新增项目 nginx 配置, 参考 [example](./examples).

2. 修改环境变量 `.env`

    ```bash
    # nginx 子配置主机映射路径
    VHOSTS_PATH=/home/happystraw/Projects/vhosts
    # 项目主机映射路径
    PROJECTS_PATH=/home/happystraw/Projects/develop/kmgitdev
    # 日志主机映射路径
    LOGS_PATH=/tmp
    # 主机IP, 用于 xdebug remote 功能
    LOCDEV=192.168.97.71
    ```

    也可以不通过改`.env`文件, 直接与命令一起执行, 如

      ```bash
    VHOSTS_PATH=/home/happystraw/Projects/vhosts docker-composer up
      ```

3. `docker-compose` 配置

    ```yaml
    # 修改 nginx vhost 配置中需要映射的端口
    ports:
      - "9901:9901"
      # ...
    ```

## Install

```bash
# 运行
docker-compose up
# 后台运行
docker-compose up -d
```

## Services

自定义镜像的配置， 详见[SERVICE SETUP](./services/README.md)