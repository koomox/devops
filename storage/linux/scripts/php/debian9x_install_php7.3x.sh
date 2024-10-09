#!/bin/bash
apt update -y
apt -y install ca-certificates apt-transport-https 
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update -y

apt -y install php7.3 php7.3-common php7.3-cli php7.3-fpm php7.3-mysql php7.3-xml php7.3-curl php7.3-mbstring php7.3-zip php7.3-bz2 php7.3-bcmath php7.3-gd php7.3-intl

cp -f /etc/php/7.3/fpm/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf.bak
cp -f /etc/php/7.3/fpm/pool.d/www.conf /etc/php/7.3/fpm/pool.d/www.conf.bak

sed -i '/;listen.mode/clisten.mode = 0660' /etc/php/7.3/fpm/pool.d/www.conf
sed -i '/^#/d;/^$/d;/^;/d' /etc/php/7.3/fpm/php-fpm.conf
sed -i '/^#/d;/^$/d;/^;/d' /etc/php/7.3/fpm/pool.d/www.conf

echo "======= /etc/php/7.3/fpm/php-fpm.conf ============"
cat /etc/php/7.3/fpm/php-fpm.conf
echo "======= /etc/php/7.3/fpm/pool.d/www.conf ========="
cat /etc/php/7.3/fpm/pool.d/www.conf