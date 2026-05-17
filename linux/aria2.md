# Aria2 下载工具                    
Aria2 官网： [Link](https://aria2.github.io/)                
Aria2 for github: [Link](https://github.com/aria2/aria2)          
webui-aria2: [Link](https://github.com/ziahamza/webui-aria2)              
AriaNg: [Link](https://github.com/mayswind/AriaNg)         
### Debian 9.x 安装 Aria2             
```sh
apt install aria2
```
开放 6800 端口       
```sh
iptables -A INPUT -p tcp --dport 6800 -j ACCEPT         
```
创建相关文件        
```sh
mkdir -p /var/lib/aria2
mkdir -p /data/aria2/downloads
mkdir -p /etc/aria2
touch /etc/aria2/aria2.session
```
配置文件 `/etc/aria2/aria2.conf`            
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/aria2/aria2.conf -o /etc/aria2/aria2.conf
```
配置启动文件 `/etc/systemd/system/aria2c.service`         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/aria2/aria2c.service -o /etc/systemd/system/aria2c.service
```
启动 Aria2          
```sh
systemctl enable aria2c
systemctl start aria2c
systemctl status aria2c
```
### CentOS 7.x 安装 Aria2           
```sh
yum install aria2
```