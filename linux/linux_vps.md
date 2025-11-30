# Linux VPS - DD 重装系统与系统优化            
参考文档: [Link](https://moeclub.org/2017/11/19/483/)           
### KVM 重装系统         
下载 linux、initrd           
```sh
mkdir /boot/ub && cd /boot/ub

wget http://ftp.debian.org/debian/dists/buster/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz
wget http://ftp.debian.org/debian/dists/buster/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux
```
grub 界面，按 `C` ，进入GRUB命令           
```sh
root=(hd0,1)
linux /boot/ub/linux
initrd /boot/ub/initrd.gz
boot
```
### [ Linux VPS ] Debian/Ubuntu/CentOS 网络安装/重装系统/纯净安装 一键脚本                 
全自动安装默认 `root` 密码:`Vicer`,安装完成后请立即更改密码.          
能够全自动重装Debian/Ubuntu/CentOS等系统.          
特别注意:OpenVZ构架不适用.           
```sh
openssl passwd -1 "$password"  # 加密明文密码, 不指定 --salt 参数，随机生成salt以使每一次生成的加密字符串不一样
```
#### 依赖包:         
```
#二进制文件    Debian/Ubuntu    RedHat/CentOS
iconv         [libc-bin]       [glibc-common]
xz            [xz-utils]       [xz]
awk           [gawk]           [gawk]
sed           [sed]            [sed]
file          [file]           [file]
grep          [grep]           [grep]
openssl       [openssl]        [openssl]
cpio          [cpio]           [cpio]
gzip          [gzip]           [gzip]
cat,cut..     [coreutils]      [coreutils]
```
确保安装了所需软件:            
```sh
#Debian/Ubuntu:
apt install -y xz-utils openssl gawk file

#RedHat/CentOS:
yum install -y xz openssl gawk file
```
如果出现了错误,请运行:          
```sh
#Debian/Ubuntu:
apt update

#RedHat/CentOS:
yum update
```
下载及说明: [查看源文件](/storage/linux/debian/DebianNET/InstallNET.sh)         
```sh
wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/DebianNET/InstallNET.sh' && chmod a+x InstallNET.sh

bash InstallNET.sh -d bookworm -v amd64 -a --mirror 'http://ftp.debian.org/debian/'
```
```sh
wget --no-check-certificate -qO InstallNET.sh 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh' && chmod a+x InstallNET.sh
```
```
Usage:
        bash InstallNET.sh      -d/--debian [dist-name]
                                -u/--ubuntu [dist-name]
                                -c/--centos [dist-version]
                                -v/--ver [32/i386|64/amd64]
                                --ip-addr/--ip-gate/--ip-mask
                                -apt/-yum/--mirror
                                -dd/--image
                                -a/-m

# dist-name: 发行版本代号
# dist-version: 发行版本号
# -apt/-yum/--mirror : 使用定义镜像
# -a/-m : 询问是否能进入VNC自行操作. -a 为不提示(一般用于全自动安装), -m 为提示.
```
使用示例:       
```sh
#使用默认镜像全自动安装
bash InstallNET.sh -d 12 -v 64 -a --mirror 'http://mirror.xtom.com.hk/debian/'

bash InstallNET.sh -d 12 -v 64 -a --mirror 'http://ftp2.cn.debian.org/debian/'

bash InstallNET.sh -d 12 -v 64 -a --mirror 'http://ftp.hk.debian.org/debian/'

bash InstallNET.sh -d 12 -v 64 -a --mirror 'http://ftp.tw.debian.org/debian/'

bash InstallNET.sh -d 12 -v 64 -a --mirror 'http://mirror.0x.sg/debian/'

bash InstallNET.sh -d 10 -v 64 -a --mirror 'http://ftp.us.debian.org/debian/'

#使用自定义镜像全自动安装
bash InstallNET.sh -c 6.9 -v 64 -a --mirror 'http://mirror.centos.org/centos'


# 以下示例中,将X.X.X.X替换为自己的网络参数.
# --ip-addr :IP Address/IP地址
# --ip-gate :Gateway   /网关
# --ip-mask :Netmask   /子网掩码

#使用自定义镜像自定义网络参数全自动安装
#bash InstallNET.sh -u 16.04 -v 64 -a --ip-addr x.x.x.x --ip-gate x.x.x.x --ip-mask x.x.x.x --mirror 'http://archive.ubuntu.com/ubuntu'

#使用自定义网络参数全自动dd方式安装
#bash InstallNET.sh --ip-addr x.x.x.x --ip-gate x.x.x.x --ip-mask x.x.x.x -dd 'https://moeclub.org/onedrive/IMAGE/Windows/win7emb_x86.tar.gz'

#使用自定义网络参数全自动dd方式安装存储在谷歌网盘中的镜像(调用文件ID的方式)
#bash InstallNET.sh --ip-addr x.x.x.x --ip-gate x.x.x.x --ip-mask x.x.x.x -dd "https://image.moeclub.org/GoogleDrive/1cqVl2wSGx92UTdhOxU9pW3wJgmvZMT_J"

#使用自定义网络参数全自动dd方式安装存储在谷歌网盘中的镜像
#bash InstallNET.sh --ip-addr x.x.x.x --ip-gate x.x.x.x --ip-mask x.x.x.x -dd "https://image.moeclub.org/GoogleDrive/1cqVl2wSGx92UTdhOxU9pW3wJgmvZMT_J"

#国内推荐使用USTC源
#--mirror 'http://mirrors.ustc.edu.cn/debian/'
#--mirror 'http://mirror.xtom.com.hk/debian/'
```
#### 重新安装 Debian Buster           
全自动重新安装 Debian buster 系统，`root` 默认密码 `Vicer` [查看源文件](/storage/linux/debian/DebianNET/InstallNET.sh)            
```sh
apt install -y gawk sed grep
apt update

wget --no-check-certificate -qO InstallNET.sh 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh' && chmod a+x InstallNET.sh

bash InstallNET.sh -d 11 -v 64 -a --mirror 'http://mirror.xtom.com.hk/debian/'
bash InstallNET.sh -d 11 -v 64 -a --mirror 'http://ftp.debian.org/debian/'
#bash InstallNET.sh -d 9 -v 64 -a --mirror 'http://mirrors.ustc.edu.cn/debian/'
```
### 安装常用软件          
安装常用软件及相关依赖        
```sh
apt install curl wget git vim sudo htop net-tools neofetch lsb-release build-essential
```
### 优化系统         
优化内核参数 [查看源文件](/storage/linux/debian/sysctl/aliyun.lightsail.sysctl.conf)        
```sh
cp -f /etc/sysctl.conf /etc/sysctl.conf.bak
wget -O /etc/sysctl.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/sysctl/aliyun.lightsail.sysctl.conf
modprobe ip_conntrack
lsmod |grep conntrack
sysctl -p
```
增加文件描述符数量，默认值太小 [查看源文件](/storage/linux/debian/sysctl/aliyun.limits.conf)            
```sh
cp -f /etc/security/limits.conf /etc/security/limits.conf.bak
wget -O /etc/security/limits.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/sysctl/aliyun.limits.conf
cat /etc/security/limits.conf
```
修改终端文件描述符数量。           
```sh
echo "ulimit -SHn 60000" >> /etc/profile
ulimit -SHn 60000
```
### 设置时区         
设置北京时间             
```sh
# 设置时区
timedatectl set-timezone Asia/Shanghai

# 查看当前时区
timedatectl
```
### 设置SSH          
自定义SSH端口，设置证书登录 [查看源文件](/storage/linux/scripts/nftables/nftables.rules.sh)         
```sh
wget -O custom_ssh_nftables.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nftables/nftables.rules.sh
chmod +x ./custom_ssh_nftables.sh
./custom_ssh_nftables.sh
```
### 获取公网IP地址          
```sh
curl https://checkip.amazonaws.com/
```