# Dnsmasq           
### Dnsmasq 树莓派           
环境基于raspbian-stretch系统              
由于树莓派的raspbian-stretch系统，默认安装了 openresolv 这个软件，导致 `/etc/resolv.conf` 这个文件变得很难修改，所以需要把它卸载掉。          
```sh
apt-get purge openresolv
```
然后重启树莓派
```sh
reboot
```
### DNS 服务器           
Dnsmasq 默认配置文件 `/etc/dnsmasq.conf`        
在电脑上以守护进程方式启动 Dnsmasq做DNS缓存服务器，添加监听地址:        
```ini
listen-address=192.168.0.x,127.0.0.1
```
在配置好Dnsmasq后，需要编译 `/etc/resolv.conf` 文件，将本机地址`localhost` 加入DNS 文件，然后再通过其他DNS服务器解析地址。
```sh
echo "nameserver 127.0.0.1" > /etc/resolv.conf
```
在 `/etc/resolv.conf` 文件中只保留 `localhost` 作为域名服务器，然后为外部域名服务器另外创建 `resolv-file` 文件。         
```sh
echo "nameserver 119.29.29.29" > /etc/dnsmasq/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/dnsmasq/resolv.conf
```
```ini
resolv-file=/etc/dnsmasq/resolv.conf
```
`strict-order` 表示严格按照 `resolv.conf` 文件中的顺序从上到下进行DNS解析，直到第一个解析成功为止。       
```ini
strict-order
```
设置上游 DNS 查询服务器              
```ini
no-resolv
resolv-file=/etc/dnsmasq/resolv.conf
strict-order
```
设置热更新 DNS hosts 目录       
```ini
no-hosts
hostsdir=/etc/dnsmasq/dns.d       
```
为特定的域名指定解析它专用的nameserver，一般为内部DNS server           
```ini
server=/xxx.com/192.168.0.1
```
打开 DNS 查询日志记录        
```ini
log-queries
```
### DHCP 服务器           
设置 DHCP 自动分配的地址范围和时间，使用 `dhcp-range` 表示启动 DHCP 服务。                
```ini
dhcp-range=192.168.0.100,192.168.0.255,12h         
```
设置子网掩码         
```ini
dhcp-option=1,255.255.255.0
```
设置网关地址            
```ini
dhcp-option=3,192.168.0.1
```
设置DHCP服务的静态绑定，设置IP/MAC地址绑定，每条一行，要绑定多少，就添加多少行。                
```ini
dhcp-host=aa:bb:cc:dd:ee:ff,192.168.0.8
```
设置 DNS 服务器地址            
```ini
dhcp-option=6,192.168.0.8,192.168.0.1
```
通过该文件读取DHCP静态绑定信息，格式与 `dhcp-host=` 右边的格式相同。`dhcp-hostsfile` 支持热更新，无需重启 Dnsmasq。           
```ini
dhcp-hostsfile=/etc/dnsmasq/dhcp.d/hosts.conf
```
创建 DHCP 静态绑定文件            
```sh
mkdir -p /etc/dnsmasq/dhcp.d
vim /etc/dnsmasq/dhcp.d/hosts.conf
```
格式
```ini
00:20:e0:3b:13:af,192.168.0.200
```
proxyDHCP           
```ini
dhcp-range=192.168.0.10,proxy
dhcp-reply-delay=1
dhcp-no-override
```