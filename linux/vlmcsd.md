# Vlmcsd          
vlmcsd for github.com: [传送门](https://github.com/Wind4/vlmcsd)         

查看日志文件           
```sh
tail -f /var/lib/vlmcsd/vlmcsd.log
```
### 启用端口         
```sh
firewall-cmd --permanent --zone=public --add-port=1688/tcp
firewall-cmd --reload
```
```sh
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 1688 -j ACCEPT
```
### 一键安装脚本        
Linux 一键安装脚本         
```sh
curl -s https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/vlmcsd/install_vlmcsd.sh -o /tmp/install_vlmcsd.sh
chmod +x /tmp/install_vlmcsd.sh
/tmp/install_vlmcsd.sh
```
Debian 9.x 一键安装脚本         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/vlmcsd/debian_vlmcsd.sh
chmod +x ./debian_vlmcsd.sh
./debian_vlmcsd.sh
```
树莓派 Raspbian 一键安装脚本           
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/vlmcsd/raspbian_vlmcsd.sh
chmod +x ./raspbian_vlmcsd.sh
./raspbian_vlmcsd.sh
```