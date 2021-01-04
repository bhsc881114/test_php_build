#安装nginx镜像
FROM nginx:latest
LABEL maintainer="dunbo2013@sina.com"
EXPOSE 80 81 443


#安装php-fpm镜像
FROM daocloud.io/php:7.2-fpm-alpine
LABEL maintainer="dunbo2013@sina.com"
# 修改镜像源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# 安装依赖,核心扩展,pecl扩展,git,npm工具
RUN apk update && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        curl-dev \
        imagemagick-dev \
        libtool \
        libxml2-dev \
        postgresql-dev \
        sqlite-dev \
    libmcrypt-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
    && apk add --no-cache \
        curl \
        git \
        imagemagick \
        mysql-client \
        postgresql-libs \
    # 配置npm中国镜像
    && pecl install imagick \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install \
        curl \
        mbstring \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        pcntl \
        tokenizer \
        xml \
        zip \
        mysqli \
    && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" gd \
    && pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis


# 对其他容器开放9000端口
EXPOSE 9000




#运行docker命令
#docker build  -t lnmp
#docker run --name myphp-fpm -v /next-student-api:/next-student-api -d lnmp
#docker run --name sx985 -p 8080:80 -v /next-student-api:/usr/share/nginx/html:ro -v /next-student-api/nginx/conf/conf.d:/etc/nginx/conf.d:ro --link myphp-fpm:php nginx
