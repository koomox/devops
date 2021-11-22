# Ubuntu 20.04          
### Ubuntu 20.x         
一键设置 Ubuntu 20.x, 更新系统, 设置防火墙, 自定义 SSH 端口和证书          
[source](/storage/linux/ubuntu/Lightsail/ubuntu20x.sh)         
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/ubuntu/Lightsail/ubuntu20x.sh
sudo chmod +x ./ubuntu20x.sh
sudo ./ubuntu20x.sh
```
### 更换更新源            
备份文件          
```sh
sudo cp -f /etc/apt/sources.list /etc/apt/sources.list.bak
```
[source](/storage/linux/ubuntu/mirrors-tuna.sh)       
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/ubuntu/mirrors-tuna.sh
sudo chmod +x ./mirrors-tuna.sh
sudo ./mirrors-tuna.sh
```
```sh
sudo apt update
sudo apt upgrade
```
### Nginx        
一键安装 Nginx 1.20.2 [查看源文件](../storage/linux/scripts/nginx/install_nginx1202.sh)         
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.20.2/install.sh
sudo chmod +x ./install.sh
sudo ./install.sh
```
配置文件      
```sh
sudo wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.1/conf.d/default.conf
```
非 80、443 端口，安卓 Let's Encrypt 证书，可以使用 DNS 验证的方式, cloudflare 界面添加 txt 记录。        
```sh
sudo rm -rf /etc/letsencrypt/live
sudo mkdir -p /etc/letsencrypt/live && cd /etc/letsencrypt/live
sudo apt install certbot
sudo certbot certonly --manual --preferred-challenges dns -d example.com --register-unsafely-without-email
```
### MariaDB           
添加公钥       
```sh
sudo apt-get install software-properties-common dirmngr
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
```
添加源       
```sh
echo -e "deb [arch=amd64,arm64,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.6/ubuntu $(lsb_release -sc) main\ndeb-src http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.6/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
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