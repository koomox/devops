# MariaDB        
Home: [Link](https://downloads.mariadb.org/)         
添加公钥          
```sh
sudo apt-get install -y apt-transport-https curl
sudo wget -O /etc/apt/trusted.gpg.d/mariadb.gpg https://mariadb.org/mariadb_release_signing_key.pgp
```    
添加debian源        
```sh
echo -e "deb http://sgp1.mirrors.digitalocean.com/mariadb/repo/10.10/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
添加ubuntu 源       
```sh
echo -e "deb http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.10/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
tuna 源          
```sh
echo -e "deb https://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.10/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/MariaDB.list
cat /etc/apt/sources.list.d/MariaDB.list
```
安装        
```sh
sudo apt-get update -y
sudo apt-get install mariadb-server -y
```
Secure the MariaDB Installation            
```sh
sudo mariadb-secure-installation
```
删除默认空密码用户， 创建带密码得root用户           
```sql
DROP USER 'root'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;

DROP USER 'mysql'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'mysql'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```
使 root 用户可以远程登录        
```sql
SELECT User, Host, Password, plugin FROM mysql.user;

DROP USER 'root'@'%';

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;

SELECT User, Host, Password, plugin FROM mysql.user;
```
创建新用户          
```sql
CREATE USER 'newuser'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'newuser'@'%' WITH GRANT OPTION;
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
### 远程管理          
使用 HeidiSQL 远程管理 MariaDB 出现错误, 检查发现默认监听地址为 `127.0.0.1`                  
```sh
netstat -anpt | grep 3306
```
修改 mariadb 配置文件 `/etc/mysql/mariadb.conf.d/50-server.cnf`          
```sh
cp -f /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.bak

sed -ri "s/^#*(bind-address)(.*)(=)( )(.*)/\1\2\3\40.0.0.0/g" /etc/mysql/mariadb.conf.d/50-server.cnf
grep -E "^#*(bind-address)(.*)(=)( )(.*)" /etc/mysql/mariadb.conf.d/50-server.cnf
```
重新启动 mariadb       
```sh
systemctl stop mysql
systemctl start mysql
systemctl status mysql
```
### Backup And Restore            
backup databse      
```sh
mysqldump -uroot -p my_database > ~/my_database_backup_$(date +"%Y%m%d").sql
```
drop and create database       
```sql
drop database my_database;
create database my_database;
```
restore database         
```sh
mysql -uroot -p my_database < my_database_backup.sql
```
### update inner join 批量更新       
MYSQL 根据SELECT数据UPDATE更新          
```sql
CREATE DATABASE IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE IF NOT EXISTS `mydb`.`table1` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `price` INT NOT NULL DEFAULT 0,
  `number` INT NOT NULL DEFAULT 0,
  `total` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) )
ENGINE = InnoDB;

SHOW DATABASES;
```
```sql
INSERT INTO `mydb`.`table1` (price, number, total)VALUES (0,0,0);
INSERT INTO `mydb`.`table1` (price, number, total)VALUES (0,0,0);
INSERT INTO `mydb`.`table1` (price, number, total)VALUES (0,0,0);
INSERT INTO `mydb`.`table1` (price, number, total)VALUES (0,0,0);
INSERT INTO `mydb`.`table1` (price, number, total)VALUES (0,0,0);
INSERT INTO `mydb`.`table1` (price, number, total)VALUES (0,0,0);
INSERT INTO `mydb`.`table1` (price, number, total)VALUES (0,0,0);
INSERT INTO `mydb`.`table1` (price, number, total)VALUES (0,0,0);
INSERT INTO `mydb`.`table1` (price, number, total)VALUES (0,0,0);
INSERT INTO `mydb`.`table1` (price, number, total)VALUES (0,0,0);

SELECT * FROM `mydb`.`table1`;
```
update          
```sql
UPDATE `mydb`.`table1` AS t1
INNER JOIN (SELECT id FROM `mydb`.`table1`) AS subquery
ON t1.`id` = subquery.id
SET t1.price = subquery.id, t1.number = subquery.id;
```
```sql
UPDATE `mydb`.`table1` AS t1
INNER JOIN (SELECT id, price, number FROM `mydb`.`table1`) AS subquery
ON t1.`id` = subquery.id
SET t1.total = subquery.price + subquery.number;
```
batch delete         
```sql
SELECT id FROM `mydb`.`table1` WHERE id NOT IN (SELECT id FROM `mydb`.`table2`);
```
```sql
DELETE FROM `mydb`.`table1` WHERE id NOT IN (SELECT id FROM `mydb`.`table2`);
```
### SQL SERVER       
update inner join        
```sql
UPDATE `mydb`.`table1`
SET price = subquery.id
FROM `mydb`.`table1`
INNER JOIN (SELECT id FROM `mydb`.`table1`) AS subquery
ON `mydb`.`table1`.`id` = subquery.id;
```