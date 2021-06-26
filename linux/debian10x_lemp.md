# Debian 10.x for LEMP         
### Nginx        
一键安装 Nginx 1.20.1 [查看源文件](../storage/linux/scripts/nginx/install_nginx1201.sh)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.20.1/install.sh
chmod +x ./install.sh
./install.sh
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

### PHP 7.4        
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
ubuntu 源          
```sh
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x4F4EA0AAE5267A6C
sudo apt update -y
sudo apt upgrade -y

echo -e "deb http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -sc) main\ndeb-src http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
cat /etc/apt/sources.list.d/php.list
```
安装 php7.4-fpm  
```sh
sudo apt-get install php7.4 php7.4-{common, cli, fpm, mysql, xml, curl, mbstring, zip, bz2, bcmath, gd, intl}
````         
```sh
apt install -y php7.4 php7.4-common php7.4-cli php7.4-fpm php7.4-mysql php7.4-xml php7.4-curl php7.4-mbstring php7.4-zip php7.4-bz2 php7.4-bcmath php7.4-gd php7.4-intl
```
配置文件          
```sh
cp -f  /etc/php/7.4/fpm/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf.bak
cp -f  /etc/php/7.4/fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf.bak

sed -i '/;listen.mode/clisten.mode = 0660' /etc/php/7.4/fpm/pool.d/www.conf
sed -i '/^#/d;/^$/d;/^;/d' /etc/php/7.4/fpm/php-fpm.conf
sed -i '/^#/d;/^$/d;/^;/d' /etc/php/7.4/fpm/pool.d/www.conf

cat /etc/php/7.4/fpm/php-fpm.conf
cat /etc/php/7.4/fpm/pool.d/www.conf
```
服务             
```sh
systemctl stop php7.4-fpm
systemctl start php7.4-fpm
systemctl status php7.4-fpm
```
### MariaDB           
添加公钥       
```sh
sudo apt-get install software-properties-common dirmngr
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
```
添加源       
```sh
echo -e "deb [arch=amd64] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.5/debian $(lsb_release -sc) main\ndeb-src http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.5/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
tuna 源       
```sh
echo -e "deb [arch=amd64] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.5/debian $(lsb_release -sc) main\ndeb-src http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.5/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
ubuntu 源       
```sh
echo -e "deb [arch=amd64,arm64,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.5/ubuntu $(lsb_release -sc) main\ndeb-src http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.5/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
```sh
sudo apt-get update -y
sudo apt-get install mariadb-server -y
```
使 root 用户可以远程登录        
```sql
SELECT User, Host, Password, plugin FROM mysql.user;

DROP USER 'root'@'%';

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;

SELECT User, Host, Password, plugin FROM mysql.user;
```
修改密码后, 仍然可以使用空密码登录如何解决?           
```sql
UPDATE mysql.user SET plugin='';
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```
```sql
UPDATE mysql.user SET plugin='mysql_native_password';
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```
### Redis         
安装 redis       
```sh
sudo apt -y install redis-server
```
开机自启动服务       
```sh
sudo systemctl enable redis-server
sudo systemctl status redis-server
```
配置文件       
```sh
sudo cp -f /etc/redis/redis.conf /etc/redis/redis.conf.bak
sed -i '/^#/d;/^$/d;/^;/d' /etc/redis/redis.conf
sudo vim /etc/redis/redis.conf
```