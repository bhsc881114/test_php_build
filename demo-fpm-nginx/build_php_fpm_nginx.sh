#!/bin/bash

# 根据 Dockerfile 构建本地镜像
docker build --progress=plain -t local_php_develop -f Dockerfile .

# 清理历史容器
docker stop local-php-develop
docker rm local-php-develop

# 启动本地容器进行测试
docker run --name local-php-develop -d -p 80:80 -p 9000:9000 local_php_develop
sleep 10s
curl -v 127.0.0.1:80/index.php

# 查看容器日志，检查问题
docker logs local-php-develop
