# Ubuntu 22.x        
### Ubuntu 22.x         
启用 root 远程登录         
```sh
sudo sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sudo sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
```
### 语言格式         
Ubuntu 安装完成后，因为时区选择的上海，结果时间显示为中文，不伦不类的，需要修改 locale 文件。         
```sh
sudo sed -i 's/zh_CN/en_US/g' /etc/default/locale
```
### 更换更新源            
备份文件          
```sh
sudo cp -f /etc/apt/sources.list /etc/apt/sources.list.bak
```  
```sh
echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted universe multiverse" | sudo tee /etc/apt/sources.list
echo "deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://security.ubuntu.com/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://security.ubuntu.com/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
```
```sh
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc) main restricted universe multiverse" | sudo tee /etc/apt/sources.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc) main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
```
```sh
sudo apt update
sudo apt upgrade
```
安装常用依赖          
```sh
sudo apt install curl wget git vim sudo htop net-tools neofetch lsb-release build-essential
```
安装多媒体解码套件          
```sh
sudo apt install ubuntu-restricted-extras
```
安装 open-vm-tools        
```sh
sudo apt install open-vm-tools open-vm-tools-desktop
```
安装 PuTTY       
```sh
sudo apt install putty
```
### 向日葵                 
```sh
wget https://down.oray.com/sunlogin/linux/SunloginClient_11.0.1.44968_amd64.deb
sudo dpkg -i SunloginClient_11.0.1.44968_amd64.deb
```
### 网易云音乐                 
```sh
wget https://d1.music.126.net/dmusic/netease-cloud-music_1.2.1_amd64_ubuntu_20190428.deb
sudo dpkg -i netease-cloud-music_1.2.1_amd64_ubuntu_20190428.deb
```
修复启动文件    
```sh
sudo vim /opt/netease/netease-cloud-music/netease-cloud-music.bash
```
```sh
HERE="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="${HERE}"/libs:$LD_LIBRARY_PATH
export QT_PLUGIN_PATH="${HERE}"/plugins
export QT_QPA_PLATFORM_PLUGIN_PATH="${HERE}"/plugins/platforms
cd /lib/x86_64-linux-gnu/
exec "${HERE}"/netease-cloud-music $@
```
### Skype                 
```sh
wget https://go.skype.com/skypeforlinux-64.deb
sudo dpkg -i skypeforlinux-64.deb
```
### Spotify                 
```sh
sudo snap install spotify
```
### Telegram        
```sh
wget --content-disposition https://telegram.org/dl/desktop/linux

xz -d tsetup.4.4.1.tar.xz
tar -xf tsetup.4.4.1.tar
sudo mv Telegram /opt
```