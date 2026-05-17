# Samba           
Samba 官网: [传送门](https://www.samba.org/)         
### Linux 编译安装 Samba         
```sh
wget -O https://download.samba.org/pub/samba/stable/samba-4.16.4.tar.gz
tar -zxf samba-4.16.4.tar.gz
cd samba-4.16.4
./configure --prefix=/usr/local/samba \
--sbindir=/usr/local/samba/sbin \
--sysconfdir=/etc/samba/ \
--mandir=/usr/share/man/ \
--without-ldap \
--without-ads \
--without-pam
make
make install
```
### Linux 在线安装 Samba         
CentOS 安装 Samba           
```sh
yum install samba samba-client
```
Debian 安装 Samba           
```sh
apt-get install samba smbclient
```
查看 Samba 版本         
```
samba -V
```
Samba 相关命令          
```sh
sudo systemctl status smbd

sudo systemctl stop smbd
sudo systemctl start smbd

sudo systemctl disable smbd
sudo systemctl enable smbd
sudo systemctl status smbd
```
### Samba 配置文件           
Samba 配置文件         
```sh
sudo vim /etc/samba/smb.conf
```
备份配置文件，并去掉注释行          
```sh
SAMBA_CONF_BAK_FILE=/etc/samba/smb.conf.bak.`date +%F_%T`
cp /etc/samba/smb.conf ${SAMBA_CONF_BAK_FILE}
grep -v -E "^#|^;" ${SAMBA_CONF_BAK_FILE} | grep . > /etc/samba/smb.conf
```
修改配置文件为如下内容         
```ini
[global]
	workgroup = WORKGROUP
	server string = Samba File Server
	netbios name = smbserver
	log file = /var/log/samba/%m.log
	log level = 1 vfs:2
	max log size = 10000
	logging = file
	security = user
	passdb backend = smbpasswd
	map to guest = bad user
	load printers = no
	vfs objects = catia fruit streams_xattr
	fruit:metadata = stream
	fruit:resource = file
	fruit:locking = none
[share]
	comment = My File Share
	path = /data/share
	browseable = yes
	read only = yes
	guest ok = yes
	public = yes
[data]
	comment = DATA
	path = /data
	browseable = yes
	read only = no
	guest ok = no
	valid users = @data
	force group = data
	create mode = 0664
	directory mode = 0775
```
创建相关文件夹         
```sh
mkdir -p /var/log/samba /data/share
```
### Linux 防火墙设置           
firewalld 防火墙           
```sh
firewall-cmd --permanent --add-port=139/tcp
firewall-cmd --permanent --add-port=445/tcp
firewall-cmd --permanent --add-port=137/udp
firewall-cmd --permanent --add-port=138/udp
systemctl restart firewalld
```
iptables 防火墙             
```sh
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 139 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 445 -j ACCEPT
iptables -A INPUT -p udp --dport 137 -j ACCEPT
iptables -A INPUT -p udp --dport 138 -j ACCEPT

iptables -A OUTPUT -p tcp --sport 139 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 445 -j ACCEPT
iptables -A OUTPUT -p udp --sport 137 -j ACCEPT
iptables -A OUTPUT -p udp --sport 138 -j ACCEPT
```
### 访问用户         
使用 `smbpasswd` 方式认证，必须先创建系统用户，再使用 `smbpasswd` 添加 Samba 用户。             
```sh
groupadd samba
useradd -r -g samba -s /bin/false samba
```
创建 samba 用户            
```sh
sudo smbpasswd -a username
```
删除 Samba 用户          
```sh
sudo smbpasswd -x username
```
创建共享文件夹，设置权限          
```sh
sudo mkdir -p /data/share/samba_newuser
sudo chown -R samba_newuser:samba_newuser /data/share/samba_newuser
sudo chmod -R 775 /data/share/samba_newuser
```
设置文件系统权限确保匿名可读           
755：确保其他用户（包括 guest）有读取和进入目录权限         
```sh
sudo chown -R nobody:nogroup /data/share
sudo chmod -R 755 /data/share
```
强制所有创建文件归属 data 组, 确认 /data 目录拥有者和权限：          
```sh
sudo chown -R root:data /data
sudo chmod -R 2775 /data   # 注意是 2775，加了 SGID 确保新建文件继承 data 组
```