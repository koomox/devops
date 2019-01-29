# socat 中转服务器            
socat: [官网](http://www.dest-unreach.org/socat/)             
### Debian 安装 socat          
在线安装 socat          
```sh
apt install socat
```
### Debian 9.x 一键安装脚本            
Debian 9.x 一键安装 socat 脚本。        
```sh
wget -O /tmp/debian9x_socat.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/socat/debian9x_socat.sh
chmod +x /tmp/debian9x_socat.sh
/tmp/debian9x_socat.sh
```
添加到系统自启动             
```sh
echo '/etc/socat/run.sh' >> /etc/rc.local
```