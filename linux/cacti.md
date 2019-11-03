# Cacti        
Home: [Link](https://www.cacti.net/)          
Download: [Link](https://www.cacti.net/download_cacti.php)          
### 部署 Cacti        
创建用户          
```sh
groupadd cacti
useradd  -r -g cacti -s /bin/false cacti
```
```sh
wget https://www.cacti.net/downloads/cacti-1.2.7.tar.gz
wget https://www.cacti.net/downloads/spine/cacti-spine-1.2.7.tar.gz
```