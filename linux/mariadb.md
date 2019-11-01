# MariaDB        
Home: [Link](https://downloads.mariadb.org/)         
添加公钥          
```sh
sudo apt-get install software-properties-common dirmngr
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com 0xF1656F24C74CD1D8
```    
添加debian源        
```sh
echo -e "deb [arch=amd64] http://mirror.lstn.net/mariadb/repo/10.4/debian $(lsb_release -sc) main\ndeb-src http://mirror.lstn.net/mariadb/repo/10.4/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
添加ubuntu 源       
```sh
echo -e "deb [arch=amd64,arm64,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu $(lsb_release -sc) main\ndeb-src http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
tuna 源          
```sh
echo -e "deb [arch=amd64] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.4/debian $(lsb_release -sc) main\ndeb-src http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.4/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
安装        
```sh
sudo apt-get update -y
sudo apt-get install mariadb-server -y
```
使 root 用户可以远程登录        
```sql
SELECT User, Host, Password, plugin FROM mysql.user;

DROP USER 'root'@'%';

GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;

SELECT User, Host, Password, plugin FROM mysql.user;
```
创建新用户          
```sql
CREATE USER 'newuser'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'newuser'@'%';
FLUSH PRIVILEGES;
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