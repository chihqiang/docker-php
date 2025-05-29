FROM php:7.3-fpm

# http://pecl.php.net/package/redis
ENV REDIS_VERSION=5.1.0
# http://pecl.php.net/package/mongodb
ENV MONGODB_VERSION=1.11.1
# http://pecl.php.net/package/rdkafka
ENV RDKAFKA_VERSION=4.1.2
# http://pecl.php.net/package/swoole
ENV SWOOLE_VERSION=4.4.26
# http://pecl.php.net/package/solr
ENV SOLR_VERSION=2.5.0

ADD sh/ext-install.sh /tmp/ext-install.sh
RUN chmod +x /tmp/ext-install.sh && sh /tmp/ext-install.sh