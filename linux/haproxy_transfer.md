# HAProxy 中转服务器           
使用 iptables 中转，效率比较低，并且有些主机并不支持，所以使用 HAProxy 作为中转服务，缺点就是只支持TCP协议。            

HAProxy: [官网](http://www.haproxy.org/)         
### 一键安装 HAProxy         
Debian 9 一键安装 HAProxy          
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/haproxy/debian9x_haproxy.sh
chmod +x ./debian9x_haproxy.sh
./debian9x_haproxy.sh
```
添加 HAProxy 防火墙规则            
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/haproxy/iptables_haproxy.sh
chmod +x ./iptables_haproxy.sh
vim ./iptables_haproxy.sh
```
添加多端口转发           
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/haproxy/debian9x_haproxy_v3.sh
chmod +x ./debian9x_haproxy_v3.sh
vim ./debian9x_haproxy_v3.sh
```