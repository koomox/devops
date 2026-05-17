# Linux Mint             
### 更换源            
```sh
sudo cp /etc/apt/sources.list.d/official-package-repositories.list /etc/apt/sources.list.d/official-package-repositories.list.bak

#Tuna
sudo sed -E -i 's/(http|https):\/\/.*.(linuxmint.com|edu.cn\/linuxmint)/https:\/\/mirrors.tuna.tsinghua.edu.cn\/linuxmint/g' /etc/apt/sources.list.d/official-package-repositories.list
sudo sed -E -i 's/(http|https):\/\/.*.(ubuntu.com|edu.cn)\/ubuntu/https:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu/g' /etc/apt/sources.list.d/official-package-repositories.list

#zju
sudo sed -E -i 's/(http|https):\/\/.*.(linuxmint.com|edu.cn\/linuxmint)/https:\/\/mirrors.zju.edu.cn\/linuxmint/g' /etc/apt/sources.list.d/official-package-repositories.list
sudo sed -E -i 's/(http|https):\/\/.*.(ubuntu.com|edu.cn)\/ubuntu/https:\/\/mirrors.zju.edu.cn\/ubuntu/g' /etc/apt/sources.list.d/official-package-repositories.list

#sudo sed -i 's/http:\/\/.*\//https:\/\/mirrors.tuna.tsinghua.edu.cn\//g' /etc/apt/sources.list.d/official-package-repositories.list

sudo apt update
sudo apt upgrade
```
安装 ssh server         
```sh
sudo apt install openssh-server
```
启动 ssh           
```sh
systemctl status sshd
systemctl start sshd
```
修改 SSH 配置文件 `/etc/ssh/sshd_config`           
```sh
sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
```
安装常用依赖          
```sh
sudo apt install curl wget git vim sudo htop net-tools neofetch lsb-release build-essential
```
安装多媒体解码套件          
```sh
sudo apt install mint-meta-codecs
```
安装输入法         
```sh
sudo apt install fcitx fcitx-config-gtk fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-ui-classic fcitx-googlepinyin
```
### Teamviewer          
```sh
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i teamviewer_amd64.deb
sudo apt install -f

cp /usr/share/applications/com.teamviewer.TeamViewer.desktop ~/Desktop
chmod +x ~/Desktop/com.teamviewer.TeamViewer.desktop
```
### 安装 Sublime Text      
```sh
sudo apt update
sudo apt install wget apt-transport-https ca-certificates software-properties-common

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt update
sudo apt install sublime-text

cp /usr/share/applications/sublime_text.desktop ~/Desktop
chmod +x ~/Desktop/sublime_text.desktop
```
安装常用插件        
```sh
git clone https://github.com/titoBouzout/SideBarEnhancements.git --depth=1
git clone https://github.com/sergeche/emmet-sublime.git --depth=1
```
### Skype          
```sh
wget https://go.skype.com/skypeforlinux-64.deb
sudo dpkg -i skypeforlinux-64.deb

cp /usr/share/applications/skypeforlinux.desktop ~/Desktop
chmod +x ~/Desktop/skypeforlinux.desktop
```
