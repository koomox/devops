# Debian 11.x for LEMP         
### Nginx        
一键安装 Nginx 1.22.x [source](/storage/linux/scripts/nginx/install_nginx1.22x.sh)         
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/install_nginx1.22x.sh
sudo chmod +x ./install_nginx1.22x.sh
sudo ./install_nginx1.22x.sh
```
service       
```sh
sudo systemctl stop nginx
sudo systemctl start nginx
sudo systemctl status nginx
```
### PHP 7.4        
添加 php 源        
```sh
sudo apt-get update -y
sudo apt-get install -y ca-certificates apt-transport-https
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo -e "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt-get update -y
```
mirrors             
```sh
echo -e "deb https://mirror.xtom.com.hk/sury/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
```
```sh
echo -e "deb https://mirror.sjtu.edu.cn/sury/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
```
ubuntu mirrors                   
```sh
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x4F4EA0AAE5267A6C
sudo apt-get update -y
sudo apt-get upgrade -y

echo -e "deb http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -sc) main\ndeb-src http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
cat /etc/apt/sources.list.d/php.list
```
安装 php7.4-fpm  
```sh
sudo apt-get install -y php7.4 php7.4-{common, cli, fpm, mysql, xml, curl, mbstring, zip, bz2, bcmath, gd, intl}
````         
```sh
sudo apt-get install -y php7.4 php7.4-common php7.4-cli php7.4-fpm php7.4-mysql php7.4-xml php7.4-curl php7.4-mbstring php7.4-zip php7.4-bz2 php7.4-bcmath php7.4-gd php7.4-intl
```
配置文件          
```sh
sudo cp -f  /etc/php/7.4/fpm/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf.bak
sudo cp -f  /etc/php/7.4/fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf.bak

sudo sed -i '/;listen.mode/clisten.mode = 0660' /etc/php/7.4/fpm/pool.d/www.conf
sudo sed -i '/^#/d;/^$/d;/^;/d' /etc/php/7.4/fpm/php-fpm.conf
sudo sed -i '/^#/d;/^$/d;/^;/d' /etc/php/7.4/fpm/pool.d/www.conf

sudo cat /etc/php/7.4/fpm/php-fpm.conf
sudo cat /etc/php/7.4/fpm/pool.d/www.conf
```
服务             
```sh
sudo systemctl stop php7.4-fpm
sudo systemctl start php7.4-fpm
sudo systemctl status php7.4-fpm
```
### MariaDB           
添加公钥       
```sh
sudo apt-get install -y apt-transport-https curl
sudo wget -O /etc/apt/trusted.gpg.d/mariadb.gpg https://mariadb.org/mariadb_release_signing_key.pgp
```
添加源       
```sh
echo -e "deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.10/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
tuna 源       
```sh
echo -e "deb http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.10/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
```sh
sudo apt-get update -y
sudo apt-get install mariadb-server -y
```
Secure the MariaDB Installation            
```sh
sudo mariadb-secure-installation
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
sudo sed -i '/^#/d;/^$/d;/^;/d' /etc/redis/redis.conf
sudo vim /etc/redis/redis.conf
```
### gitlab-ce         
添加源          
```sh
sudo wget -O /etc/apt/trusted.gpg.d/gitlab.gpg https://packages.gitlab.com/gpg.key
echo -e "deb http://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/gitlab-ce.list
cat /etc/apt/sources.list.d/gitlab-ce.list
```
install gitlab-ce             
```sh
sudo apt-get update -y
sudo apt-get install -y gitlab-ce
```
### docker-ce        
添加源         
```sh
sudo wget -O /etc/apt/trusted.gpg.d/docker.gpg https://download.docker.com/linux/debian/gpg
echo -e "deb https://download.docker.com/linux/debian $(lsb_release -sc) stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
cat /etc/apt/sources.list.d/docker-ce.list
```
```sh
echo -e "deb https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian $(lsb_release -sc) stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
cat /etc/apt/sources.list.d/docker-ce.list
```
```sh
echo -e "deb https://mirrors.ustc.edu.cn/docker-ce/linux/debian $(lsb_release -sc) stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
cat /etc/apt/sources.list.d/docker-ce.list
```
install docker-ce         
```sh
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```