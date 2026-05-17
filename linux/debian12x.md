# Debian 12.x             
### 更换更新源            
Debian 默认只支持HTTP源，若要使用HTTPS源，需要安装 apt-transport-https         
```sh
sudo apt-get install apt-transport-https
```
备份文件          
```sh
sudo cp -f /etc/apt/sources.list /etc/apt/sources.list.bak
```  
```sh
echo "deb http://deb.debian.org/debian/ $(lsb_release -sc) main contrib non-free non-free-firmware" > /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ $(lsb_release -sc) main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ $(lsb_release -sc)-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ $(lsb_release -sc)-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list
``` 
```sh
echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ $(lsb_release -sc) main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list
echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ $(lsb_release -sc) main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ $(lsb_release -sc)-updates main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ $(lsb_release -sc)-updates main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
```
### 用户管理           
新增用户        
```sh
sudo useradd -m -d /home/dev -s /bin/bash -c "Development User" dev
```
### 安装 sudo 命令      
Debian 默认没有 `sudo` 命令，可以先输入 `su` 命令，再输入 root 命令。然后使用如下命令安装 `sudo` 命令。              
```sh
apt install sudo vim
```
```sh
vim /etc/sudoers
```
添加一行，其中的 username 替换为你的用户名。            
```
"username"    ALL=(ALL:ALL) ALL
```
如果不想输入密码使用下面的格式
```
"username"    ALL=(ALL:ALL) NOPASSWD:ALL
```
### Debian 12.x         
安装常用软件         
```sh
sudo apt install vim wget curl git gcc g++ make gdb build-essential htop iftop net-tools neofetch
```
启用 root 远程登录         
```sh
sudo sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sudo sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
```
禁用 root 远程登录，并启用证书登录        
```sh
sudo sed -E -i '/^#*Port /cPort 22' /etc/ssh/sshd_config
sudo sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sudo sed -E -i '/^#*PermitRootLogin/cPermitRootLogin no' /etc/ssh/sshd_config
sudo sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' /etc/ssh/sshd_config
sudo sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' /etc/ssh/sshd_config
sudo sed -E -i '/^#*MaxAuthTries/cMaxAuthTries 2' /etc/ssh/sshd_config
sudo sed -E -i '/^#*MaxSessions/cMaxSessions 2' /etc/ssh/sshd_config
sudo sed -E -i '/^#*MaxStartups/cMaxStartups 2:30:10' /etc/ssh/sshd_config
grep -E "^#*(Port|PermitEmptyPasswords|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|MaxAuthTries|MaxSessions|MaxStartups)" /etc/ssh/sshd_config
```       
创建新用户        
```sh
sudo useradd -m -d /home/dev -s /bin/bash dev
```     
生成 ssh 公钥和私钥
```sh
ssh-keygen -t rsa -b 4096 -C "email@example.com" -f example.com.key
```     
设置 ssh 证书       
```sh
rm -rf ~/.ssh
rm -rf ~/.ssh/authorized_keys
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
vim ~/.ssh/authorized_keys
```
### 系统优化       
一键设置优化 Debian（nftabes） [查看源文件](/storage/linux/debian/Lightsail/debian11x.sh)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/Lightsail/debian11x.sh
chmod +x ./debian11x.sh
./debian11x.sh
```
一键设置优化 Debian（iptabes） [查看源文件](/storage/linux/debian/Lightsail/debian12x.sh)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/Lightsail/debian12x.sh
chmod +x ./debian12x.sh
./debian12x.sh
```
### 网络设置             
备份文件          
```sh
sudo cp -f /etc/network/interfaces /etc/network/interfaces.bak
```
```sh
iface ens32 inet static
address 192.168.0.100
netmask 255.255.255.0
gateway 192.168.0.1
```
