#!/bin/bash

# ===============================================================
# 🚀 ondrej安装
#
# 👉 支持系统：
#       - Ubuntu
# 👉 使用方式（直接运行）：
#      bash -c "$(curl -fsSL https://raw.githubusercontent.com/chihqiang/docker-php/main/ondrej.sh)"
#
# 🧑‍💻 作者：zhiqiang
# ===============================================================

# 检查是否使用 root 用户
if [[ $(id -u) -ne 0 ]]; then
    echo "❌ 请使用 root 用户或具有 sudo 权限的用户执行此脚本！"
    exit 1
fi

# 检查操作系统
OS=$(lsb_release -i | awk -F: '{print $2}' | sed 's/^[ \t]*//')  # 直接去掉前后空格
if [[ "$OS" != "Ubuntu" && "$OS" != "Debian" ]]; then
    echo "❌ 此脚本仅支持 Ubuntu 或 Debian 系统！"
    exit 1
fi

# 可选版本列表
versions=("7.4" "8.0" "8.1" "8.2" "8.3")
echo "请选择要安装的 PHP 版本："
select version in "${versions[@]}"; do
    if [[ -n "$version" ]]; then
        echo "你选择了 PHP $version"
        break
    else
        echo "无效选择，请重新输入"
    fi
done

# 更新并添加 PPA
echo "🔄 正在更新软件包列表..."
apt update
echo "🔄 正在安装软件包支持工具..."
apt install -y software-properties-common
echo "🔄 正在添加 PHP PPA 仓库..."
add-apt-repository -y ppa:ondrej/php
echo "🔄 更新软件包列表..."
apt update

# 安装 PHP 及常用模块
EXTENSIONS=(
    "cli"
    "fpm"
    "common"
    "mbstring"
    "xml"
    "gd"
    "curl"
    "mysql"
    "zip"
    "bcmath"
    "intl"
    "readline"
    "bz2"
    "redis"
    "memcached"
    "opcache"
    "soap"
    "swoole"
    "imagick"
)

for ext in "${EXTENSIONS[@]}"; do
    echo "🔧 正在安装 PHP $version 扩展：$ext"
    if ! apt install -y "php$version-$ext"; then
        echo "⚠️ PHP $version 扩展 $ext 安装失败，继续安装其他扩展..."
    fi
done

# 安装完成提示
php_path="/usr/bin/php$version"
if [[ -x "$php_path" ]]; then
    echo "🎉 PHP $version 安装完成：$php_path"
    "$php_path" -v
else
    echo "❌ PHP $version 安装失败！"
    exit 1
fi
