## 🏗️ 构建镜像

支持多个 PHP 版本和模式（CLI/FPM）：

~~~
# PHP 7.x
docker build -f 7.1-cli/Dockerfile -t zhiqiangwang/php:7.1-cli .
docker build -f 7.1-fpm/Dockerfile -t zhiqiangwang/php:7.1-fpm .

docker build -f 7.2-cli/Dockerfile -t zhiqiangwang/php:7.2-cli .
docker build -f 7.2-fpm/Dockerfile -t zhiqiangwang/php:7.2-fpm .

docker build -f 7.3-cli/Dockerfile -t zhiqiangwang/php:7.3-cli .
docker build -f 7.3-fpm/Dockerfile -t zhiqiangwang/php:7.3-fpm .

docker build -f 7.4-cli/Dockerfile -t zhiqiangwang/php:7.4-cli .
docker build -f 7.4-fpm/Dockerfile -t zhiqiangwang/php:7.4-fpm .

# PHP 8.x
docker build -f 8.1-cli/Dockerfile -t zhiqiangwang/php:8.1-cli .
docker build -f 8.1-fpm/Dockerfile -t zhiqiangwang/php:8.1-fpm .

docker build -f 8.2-cli/Dockerfile -t zhiqiangwang/php:8.2-cli .
docker build -f 8.2-fpm/Dockerfile -t zhiqiangwang/php:8.2-fpm .
~~~

## 🎯 扩展镜像

```
# composer 支持
docker build --build-arg="IMAGE_TAG=7.4-fpm" -f Dockerfile.composer -t zhiqiangwang/php:7.4-fpm-composer .

# nginx + fpm 一体化
docker build --build-arg="IMAGE_TAG=7.4-fpm" -f Dockerfile.nginx -t zhiqiangwang/php:7.4-fpm-nginx .

# phpMyAdmin 镜像
docker build -f Dockerfile.phpmyadmin -t zhiqiangwang/php:phpmyadmin .
```

## 💼 特殊镜像

**企业微信会话内容存档（wxwork-finance）镜像**已单独维护，见仓库：
 https://github.com/chihqiang/docker-php-wxwork-finance

~~~
zhiqiangwang/php:7.4-fpm-wxwork-finance
zhiqiangwang/php:7.4-cli-wxwork-finance
~~~

## 🚀 启动容器示例

~~~
docker run --name myphp -p 9000:9000 -v $(pwd):/var/www/html -d zhiqiangwang/php:7.4-fpm
~~~

### phpMyAdmin（基于 nginx + fpm）

```
docker run --name phpmyadmin -p 8080:80 -e PMA_HOST=192.168.3.110 -d zhiqiangwang/php:7.4-fpm-nginx
```

### 项目部署（ThinkPHP 示例）

```
docker run --name myphp -p 8080:80 \
  -v $(pwd):/var/www/html \
  -v $(pwd)/docker/thinkphp.conf:/etc/nginx/sites-enabled/default \
  -d zhiqiangwang/php:7.4-fpm-nginx
```

## 📁 常见配置目录

- `/etc/nginx`            — nginx 配置
- `/usr/local/etc`        — PHP/FPM 配置
- `/etc/supervisor`       — supervisor 配置
- `/var/spool/cron/crontabs` — crontab 任务计划

## 🔧 常见命令

~~~
# 添加定时任务
echo "* * * * * Command" >> /var/spool/cron/crontabs/root
chmod 600 /var/spool/cron/crontabs/root
/etc/init.d/cron start

# 启动方式
nginx -g "daemon off;"
php -i | grep php.ini
php-fpm --nodaemonize
~~~

## 📜 日志打印到 Docker 控制台

```
ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log
```

## 🧩 启动 Nginx + PHP 分离容器

1. #### 创建网络：

```
docker network create php-nginx-network
```

2. #### 启动 nginx：

```
docker run --name nginx -d -p 8080:80 -v tp:/code nginx:latest
```

3. #### 加入网络：

```
docker network connect php-nginx-network nginx
```

4. #### 启动 PHP 容器：

```
docker run --name myphp \
  -v tp:/var/www/html \
  --network php-nginx-network \
  -p 9000:9000 \
  -d zhiqiangwang/php:8.2-fpm-composer
```

🔍 **注意：**

- Nginx `root` 目录应设置为 PHP 容器中的 `/var/www/html`
- `fastcgi_pass` 配置为 `myphp:9000`
