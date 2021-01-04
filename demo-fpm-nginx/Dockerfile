# PHP 官方镜像
FROM php:7.2-fpm

# 加速软件包安装
RUN echo "deb http://nginx.org/packages/debian jessie nginx" >> /etc/apt/sources.list.d/nginx.list

# 安装 Nginx 与常用命令
RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
RUN apt-get update && apt-get install -y \
		curl gnupg ca-certificates lsb-release nginx \
		vim telnet bash-completion

# 安装 PHP 官方扩展，文档 https://github.com/docker-library/docs/tree/master/php
RUN docker-php-ext-install pdo pdo_mysql mysqli

# 安装 pecl 扩展，如 redis
RUN apt-get install -y autoconf gcc make autoconf libc-dev pkg-config \
    && pecl install redis-2.2.8 \
	&& docker-php-ext-enable redis

# 复制 PHP 代码
COPY ./php/ /var/www/html/
# 复制 Nginx 配置，参考官网 https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# 启动脚本，仅 DEMO 演示，应该使用其它方式运行，避免 php-fpm 退出无法检测
RUN echo 'php-fpm -D && nginx -g "daemon off;"' > /usr/local/sbin/start.sh
CMD ["sh","/usr/local/sbin/start.sh"]
