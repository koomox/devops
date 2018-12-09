# HAProxy 中转服务器           
使用 iptables 中转，效率比较低，并且有些主机并不支持，所以使用 HAProxy 作为中转服务，缺点就是只支持TCP协议。            

HAProxy: [官网](http://www.haproxy.org/)         
### 一键安装 HAProxy         
Debian 9 一键安装 HAProxy          
```sh
curl -LO https://github.com/koomox/devops/blob/master/storage/linux/scripts/haproxy/debian9x_haproxy.sh
chmod +x ./debian9x_haproxy.sh
./debian9x_haproxy.sh
```