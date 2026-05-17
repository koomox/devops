#!/bin/bash
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x4F4EA0AAE5267A6C

echo -e "deb http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -sc) main\ndeb-src http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
cat /etc/apt/sources.list.d/php.list

apt update -y
apt upgrade -y

apt install -y php7.3 php7.3-common php7.3-cli php7.3-fpm php7.3-mysql php7.3-xml php7.3-curl php7.3-mbstring php7.3-zip php7.3-bz2 php7.3-bcmath php7.3-gd php7.3-intl

cp -f  /etc/php/7.3/fpm/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf.bak
cp -f  /etc/php/7.3/fpm/pool.d/www.conf /etc/php/7.3/fpm/pool.d/www.conf.bak

sed -i '/;listen.mode/clisten.mode = 0660' /etc/php/7.3/fpm/pool.d/www.conf
sed -i '/^#/d;/^$/d;/^;/d' /etc/php/7.3/fpm/php-fpm.conf
sed -i '/^#/d;/^$/d;/^;/d' /etc/php/7.3/fpm/pool.d/www.conf

cat /etc/php/7.3/fpm/php-fpm.conf
cat /etc/php/7.3/fpm/pool.d/www.conf

systemctl stop php7.3-fpm
systemctl start php7.3-fpm
systemctl status php7.3-fpm

apt install -y software-properties-common dirmngr
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8

echo -e "deb [arch=amd64,arm64,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu $(lsb_release -sc) main\ndeb-src http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list

apt update -y
apt upgrade -y

apt install -y mariadb-server

wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.1/install.sh
chmod +x ./install.sh
./install.sh

wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/nginx-ssl-fpm.conf

wget https://wordpress.org/latest.tar.gz

mkdir -p /web
\rm -rf /web/wordpress
tar -zxf latest.tar.gz -C /web

cp /web/wordpress/wp-config-sample.php /web/wordpress/wp-config.php 

chmod -R 750 /web/wordpress
chown -R www-data:www-data /web/wordpress


wget https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-all-languages.tar.xz

\rm -rf /web/phpMyAdmin
mkdir -p /web/phpMyAdmin
xz -d phpMyAdmin-4.9.2-all-languages.tar.xz
tar --strip-components 1 -C /web/phpMyAdmin -xf phpMyAdmin-4.9.2-all-languages.tar

cd /web/phpMyAdmin
\cp -f config.sample.inc.php config.inc.php

secret=`openssl rand -base64 50  | tr -dc A-Z-a-z-0-9 | head -c${1:-32}`
sed -ri "s/cfg\['blowfish_secret'\] = '.*'/cfg['blowfish_secret'] = '${secret}'/" config.inc.php
grep -E "^*cfg\['blowfish_secret'\]" config.inc.php

sed -ri "s/^.*(cfg)(.*')(pmadb|bookmarktable|relation|table_info|table_coords|pdf_pages|column_info|history|table_uiprefs|tracking|userconfig|recent|favorite|users|usergroups|navigationhiding|savedsearches|central_columns|designer_settings|export_templates)('.*)$/\$\1\2\3\4/g" config.inc.php

grep -E "cfg\['Servers'\]" config.inc.php

chmod -R 750 /web/phpMyAdmin
chown -R www-data:www-data /web/phpMyAdmin

wget -O /etc/nginx/conf.d/phpmyadmin.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/conf.d/phpmyadmin.conf

phpmyadmin=`openssl rand -base64 50  | tr -dc A-Z-a-z-0-9 | head -c${1:-16}`
sed -ri "s/^(.*)(location)(.*)phpmyadmin(.*)/\1\2\3${phpmyadmin}\4/g" /etc/nginx/conf.d/phpmyadmin.conf
grep -E "^(.*)(location)(.*)\/(.*)" /etc/nginx/conf.d/phpmyadmin.conf
