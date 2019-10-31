# Debian 9.x for LEMP         
### Nginx        
一键安装 Nginx 1.16.0 [查看源文件](../storage/linux/scripts/nginx/install_nginx1160.sh)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/install_nginx1160.sh
chmod +x ./install_nginx1160.sh
./install_nginx1160.sh
```
配置文件          
```sh
sed -i 's/localhost/*.com www.*.com/g' /etc/nginx/conf.d/*.com.conf
sed -i 's/$domain/*.com/g' /etc/nginx/conf.d/*.com.conf
sed -i 's/\/var\/www\/html/\/${public_path}/g' /etc/nginx/conf.d/*.com.conf
```
```sh
mkdir -p /etc/letsencrypt/live/$domain
touch /etc/letsencrypt/live/$domain/fullchain.pem
touch /etc/letsencrypt/live/$domain/privkey.pem
```
```sh
sed -i 's/phpmyadmin/pma/g' /etc/nginx/conf.d/phpmyadmin.conf
cat /etc/nginx/conf.d/phpmyadmin.conf
```
服务       
```sh
systemctl stop nginx
systemctl start nginx
systemctl status nginx
```
```sh
echo "hello world" > /var/www/letsencrypt/index
```

### PHP 7.3        
添加 php 源        
```sh
apt update -y
apt install ca-certificates apt-transport-https -y
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update -y
```
使用香港镜像加速安装          
```sh
apt update -y
apt install ca-certificates apt-transport-https 
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://mirror.xtom.com.hk/sury/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update
```
安装 php7.3-fpm           
```sh
apt install -y php7.3 php7.3-common php7.3-cli php7.3-fpm php7.3-mysql php7.3-xml php7.3-curl php7.3-mbstring php7.3-zip php7.3-bz2 php7.3-bcmath php7.3-gd php7.3-intl
```
配置文件          
```sh
cp -f  /etc/php/7.3/fpm/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf.bak
cp -f  /etc/php/7.3/fpm/pool.d/www.conf /etc/php/7.3/fpm/pool.d/www.conf.bak

sed -i '/;listen.mode/clisten.mode = 0660' /etc/php/7.3/fpm/pool.d/www.conf
sed -i '/^#/d;/^$/d;/^;/d' /etc/php/7.3/fpm/php-fpm.conf
sed -i '/^#/d;/^$/d;/^;/d' /etc/php/7.3/fpm/pool.d/www.conf

cat /etc/php/7.3/fpm/php-fpm.conf
cat /etc/php/7.3/fpm/pool.d/www.conf
```
服务             
```sh
systemctl stop php7.3-fpm
systemctl start php7.3-fpm
systemctl status php7.3-fpm
```
### MariaDB           
添加公钥       
```sh
sudo apt-get install software-properties-common dirmngr
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
```
添加源       
```sh
echo -e "deb [arch=amd64] http://mirror.lstn.net/mariadb/repo/10.4/debian $(lsb_release -sc) main\ndeb-src http://mirror.lstn.net/mariadb/repo/10.4/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
tuna 源       
```sh
echo -e "deb [arch=amd64] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.4/debian $(lsb_release -sc) main\ndeb-src http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.4/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
ubuntu 源       
```sh
echo -e "deb [arch=amd64,arm64,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu $(lsb_release -sc) main\ndeb-src http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
```sh
sudo apt-get update -y
sudo apt-get install mariadb-server -y
```
使 root 用户可以远程登录        
```sql
SELECT User, Host, Password FROM mysql.user;

DROP USER 'root'@'%';

GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;

SELECT User, Host, Password, plugin FROM mysql.user;
```
修改密码后, 仍然可以使用空密码登录如何解决?           
```sql
UPDATE mysql.user SET plugin='';
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```