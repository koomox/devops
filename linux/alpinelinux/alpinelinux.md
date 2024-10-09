# Alpine Linux 3.17.0             
Linux Kernel 5.10.43               
下载地址: [Link](https://alpinelinux.org/downloads/)             
### 安装        
不管是刻录U盘还是在虚拟机里启动，进入终端之后，输入 `root` 默认无密登陆，然后执行 `setup-alpine` 命令，在终端上启动他的安装程序。              
键盘布局选择 `us` , 后面的配置项默认回车。          
时区选择 Asia，Shanghai。             
软件源，如果联网了，输入 `f` 回车，让程序自动匹配当前最快的软件源。可能会花一点时间。尽量不要跳过，因为后面格式化硬盘的时候需要联网安装相关的命令。               
有时候网络不通，输入 `e` 回车，添加源到文件。              
```
https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.17/main
https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.17/community
```
之后的每一步要仔细看了，就询问你"Availabe disks are"和"Which disks would you like to use?"来选择安装的硬盘，可以输入"?"来列举可用硬盘，然后手动输入，这里这里我安装到 `sda` ，你有需要可以选择其他位置。         
在询问你"How would you like to use it?",这里输入 `sys` 硬盘安装，其余的"data"、"lvm"可以了解一下，这里不再赘述。            
格式化硬盘然后复制文件需要些时间，完成之后会提示"Installation is complete",这时候拔掉U盘或者设置硬盘第一启动，就可以重启了。          
### 修改更新源           
更换更新源文件 `/etc/apk/repositories`          
```sh
sed -i 's/http:\/\/.*\//https:\/\/mirrors.tuna.tsinghua.edu.cn\//g' /etc/apk/repositories
```
Tuna 源     
```sh
cp /etc/apk/repositories /etc/apk/repositories.bak
echo -e "https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.17/main\nhttps://mirrors.tuna.tsinghua.edu.cn/alpine/v3.17/community" > /etc/apk/repositories
cat /etc/apk/repositories
```
阿里云源        
```sh
cp /etc/apk/repositories /etc/apk/repositories.bak
echo -e "https://mirrors.aliyun.com/alpine/v3.17/main\nhttps://mirrors.aliyun.com/alpine/v3.17/community" > /etc/apk/repositories
cat /etc/apk/repositories
```
更新系统          
```sh
apk update
```
安装软件，Alpine Linux 默认是没有 `bash` 的，需要手动安装。         
```sh
apk add --no-cache bash vim wget curl git htop         
```
修改默认 shell 为 `bash`, 把 `/bin/ash` 替换为 `/bin/bash`               
```sh
vim /etc/passwd
```
### 网络设置       
配置文件 `/etc/network/interfaces`         
```sh
vim /etc/network/interfaces
```
VMware NAT 模式设置一个就可以了。           
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
        address 192.168.1.150
        netmask 255.255.255.0
        gateway 192.168.1.1
```
VirtualBox 需要设置 NAT + Host only 两个网卡, NAT 用于上网， host only 用于 主机访问虚拟机。          
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.168.56.5
	netmask 255.255.255.0
```
重启网络服务       
```sh
/etc/init.d/networking restart
```
修改 SSH 配置文件 `/etc/ssh/sshd_config`       
```sh
sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
```
打开IP转发            
```sh
echo "1" > /proc/sys/net/ipv4/ip_forward

sed -i "1inet.ipv4.ip_forward = 1" /etc/sysctl.d/00-alpine.conf
cat /etc/sysctl.d/00-alpine.conf
```
### iptables         
安装 iptables
```sh
apk add iptables
```
开机自启动           
```sh
rc-update add iptables
```
保存 iptables 规则         
```sh
/etc/init.d/iptables save
```
保存配置         
```sh
lbu ci
```
### 代理           
安装 privoxy       
```sh
apk add --no-cache privoxy
```
配置文件 `/etc/privoxy/config`，`listen-address` 参数为监听地址端口，`forward-socks5` 为转发地址端口。        
```sh
cp /etc/privoxy/config /etc/privoxy/config.bak
sed -i '/^#/d;/^$/d' /etc/privoxy/config
sed -i '/listen-address/clisten-address 0.0.0.0:1090' /etc/privoxy/config
sed -i '/forwarded-/aforward-socks5 \/ 127.0.0.1:1080 .' /etc/privoxy/config
cat /etc/privoxy/config
```
设置开机自启动          
```sh
rc-update add privoxy
```
### 历史记录 history       
Alpine Linux 使用 busybox, 历史文件 `~/.ash_history`, 清除历史记录使用下面的命令。                  
```sh
echo "" > ~/.ash_history && reboot
```