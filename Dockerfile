# 采用alpine官方镜像做为运行时镜像
FROM ubuntu:18.04

# 设定工作目录
WORKDIR /app

# 设置时区
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo Asia/Shanghai > /etc/timezone

# 安装基础命令（选用国内阿里云镜像源以提高下载速度）
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    nginx \
    php7.2 \
    php7.2-fpm \
    php7.2-gd \
    php7.2-mbstring \
    php7.2-zip 

# 将项目目录下所有文件拷贝到工作目录
COPY . /app

# 替换nginx、fpm、php配置
RUN cp /app/config/nginx.conf /etc/nginx/conf.d/default.conf \
    && cp /app/config/fpm.conf /etc/php/7.2/fpm/pool.d/www.conf \
    && cp /app/config/php.ini /etc/php/7.2/fpm/php.ini \
    && mkdir -p /run/nginx \
    && mkdir -p /run/php \
    && chmod -R 777 /app/runtime \
    && mv /usr/sbin/php-fpm7.2 /usr/sbin/php-fpm \
    && groupadd nobody

# 暴露端口
# 此处端口必须与构建小程序服务端时填写的服务端口和探活端口一致，不然会部署失败
EXPOSE 80

# 执行启动命令
CMD ["sh", "run.sh"]
