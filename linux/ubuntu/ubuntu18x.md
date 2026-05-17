# Ubuntu 18.x         
### Oracle Cloud Ubuntu 18.x         
一键设置 Ubuntu 18.x, 更新系统, 设置防火墙, 自定义 SSH 端口和证书          
[source](/storage/linux/ubuntu/oraclecloud/ubuntu18x.sh)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/ubuntu/oraclecloud/ubuntu18x.sh
sudo chmod +x ./ubuntu18x.sh
sudo ./ubuntu18x.sh
```
启用 root 远程登录         
```sh
sudo sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sudo sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
```
删除 oracle-cloud-agent     
```sh
sudo snap remove oracle-cloud-agent
```
### Nginx        
一键安装 Nginx 1.24.x [source](/storage/linux/scripts/nginx/install_nginx1.24x.sh)         
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/install_nginx1.24x.sh
sudo chmod +x ./install_nginx1.24x.sh
sudo ./install_nginx1.24x.sh
```
编译安装 Nginx 1.24.x [source](/storage/linux/scripts/nginx/make_nginx1.24x.sh)     
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/make_nginx1.24x.sh
sudo chmod +x ./make_nginx1.24x.sh
sudo ./make_nginx1.24x.sh
```
配置文件      
```sh
sudo wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/default.conf
```
非 80、443 端口，安卓 Let's Encrypt 证书，可以使用 DNS 验证的方式, cloudflare 界面添加 txt 记录。        
```sh
sudo rm -rf /etc/letsencrypt/live
sudo mkdir -p /etc/letsencrypt/live && cd /etc/letsencrypt/live
sudo apt install certbot -y
sudo certbot certonly --manual --preferred-challenges dns -d example.com --register-unsafely-without-email
```
### 禁用 Nvidia 独显       
Ubuntu 默认使用 nouveau 开源驱动程序驱动 Nvidia 显卡，但是该驱动经常导致 Nvidia 显卡无法正常工作，甚至无法引导，如果需要无法引导的情况需要将其禁用。       
Ubuntu 引导GRUB界面，按 `E` 键，在 `splash` 后面添加 `nouveau.modeset=0`，保存后按 `F10` 引导。        
安装完 Ubuntu 系统后，还需要修改 GRUB 引导项。       
```sh
sudo vim /etc/default/grub
```
在 `GRUB_CMDLINE_LINUX_DEFAULT` 后面的 `splash` 后面添加 `nouveau.modeset=0`。         
然后更新 GRUB。        
```sh
sudo update-grub
```
禁用 nouveau 驱动        
```sh
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
```
查看文件          
```sh
cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
```
重新生成 kernel initramfs，然后重启电脑。          
```sh
sudo update-initramfs -u
```
验证 nouveau 驱动是否被禁用       
```sh
lsmod | grep nouveau
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
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc) main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse" >> /etc/apt/sources.list
```
```sh
sudo apt update
sudo apt upgrade
```
### 安装 Nvidia 驱动        
```sh
sudo add-apt-repository ppa:graphics-drivers/ppa

sudo apt update
sudo apt install nvidia-*
```
上面的命令，安装驱动失败，使用下面的命令才搞定。       
```sh
ubuntu-drivers devices
```
Nvidia GTX960M 独显             
```
sudo apt install nvidia-driver-390
```
查看 Nvidia 显卡信息        
```sh
lsmod | grep -i nvidia
```
### 安装音视频解码器     
安装完 ubuntu 之后，本来想打开音乐听听，结果什么声音都没有，安装音视频编解码器就可以了。             
```sh
sudo apt install ubuntu-restricted-extras
```
### 安装 Sublime Text       
```sh
sudo apt update
sudo apt install wget apt-transport-https ca-certificates software-properties-common

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt update
sudo apt install sublime-text
```
二进制包安装 Sublime Text         
```sh
wget https://download.sublimetext.com/sublime_text_3_build_3211_x64.tar.bz2

tar -xjvf sublime_text_3_build_3211_x64.tar.bz2

sudo mv sublime_text_3 /opt/sublime_text

cp /opt/sublime_text/sublime_text.desktop ~/Desktop
chmod +x ~/Desktop/sublime_text.desktop
```
安装好仍然无法打开，因为缺少libgtk包        
```sh
sudo apt install libgtk2.0-0
```
安装常用插件         
```sh
git clone https://github.com/titoBouzout/SideBarEnhancements.git --depth=1
```
```sh
git clone https://github.com/sergeche/emmet-sublime.git --depth=1
```
### 安装 VSCode          
二进制包安装 VSCode         
```sh
sudo dpkg -i code_1.43.2-1585036376_amd64.deb

cp /usr/share/applications/code.desktop ~/Desktop
chmod +x ~/Desktop/code.desktop
```
### 添加代理          
国内下载软件的时候非常慢，可以使用代理加速下载，下面的方法重启电脑后即失效。（对apt、wget、等命令有效）                      
```sh
export http_proxy="http://127.0.0.1:1080"
export https_proxy="socks5://127.0.0.1:1080"

export ALL_PROXY=socks5://127.0.0.1:1080
```
编辑 `~/.bashrc` 通过设置alias简写来简化操作，每次要用的时候输入setproxy，不用了就unsetproxy。          
```sh
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:1080"
alias unsetproxy="unset ALL_PROXY"
```
有些应用程序只支持HTTP代理，可以通过 `privoxy` 实现。         
```sh
sudo apt install privoxy
```
设置配置文件          
```sh
sudo cp /etc/privoxy/config /etc/privoxy/config.bak
sed -i '/^#/d;/^$/d' /etc/privoxy/config
```
添加下面两行实现了SOCKS转HTTP代理，监听1090端口转发到本机1080端口。 `forward-socks5` 最后的小点不要漏了。         
```ini
forward-socks5 / 127.0.0.1:1080 .
listen-address 0.0.0.1:1090
```
```sh
sed -i '/listen-address/clisten-address 0.0.0.0:1090' /etc/privoxy/config
sed -i '/forwarded-/aforward-socks5 \/ 127.0.0.1:1080 .' /etc/privoxy/config
cat /etc/privoxy/config
```
### 安装输入法            
```sh
sudo apt install fcitx fcitx-googlepinyin
```
配置文件        
```sh
echo -e "export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS=\"@im=fcitx\"" >> ~/.xprofile
```
还需要在语言中设置为 fcitx              
![fcitx](/static/images/wiki/IMG_20190225_122500.png)
### Chrome 浏览器           
在线安装 Chrome 最新稳定版          
```sh
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo apt update
sudo apt install google-chrome-stable
```
二进制包安装 Chrome 最新稳定版         
```sh
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo dpkg -i google-chrome-stable_current_amd64.deb

echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

sudo apt update
```
创建桌面图标           
```sh
cp /usr/share/applications/google-chrome.desktop ~/Desktop
chmod +x ~/Desktop/google-chrome.desktop
```
在线安装 Chromium Browser         
```sh
sudo apt install chromium-browser
```
### Telegram           
使用二进制安装包安装最新版 Telegram-desktop，安装后在终端中执行 `telegram-desktop` 会自动创建应用程序图标。             
```sh
wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/

/opt/Telegram/Telegram
```
一键安装 Telegram-desktop 最新版，安装后执行 `source /etc/source && Telegram`。 如果遇到无法启动的情况，应该是之前安装过 Telegram-desktop 生成的配置文件导致的，`rm -rf ~/.local/share/TelegramDesktop` 删除配置文件即可。       
```sh
curl -s https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/telegram/latest_telegram_desktop_v3.sh -o /tmp/latest_telegram_desktop_v3.sh
chmod +x /tmp/latest_telegram_desktop_v3.sh
/tmp/latest_telegram_desktop_v3.sh
```
Telegram-desktop 创建的启动文件，在 `~/.local/share/applications` 路径下。      
```sh
cp ~/.local/share/applications/telegramdesktop.desktop ~/Desktop
sudo cp ~/.local/share/applications/telegramdesktop.desktop /usr/share/applications

chmod +x ~/Desktop/telegramdesktop.desktop
sudo chmod +x /usr/share/applications/telegramdesktop.desktop

rm ~/.local/share/applications/telegramdesktop.desktop
```
### Teamviewer          
```sh
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i teamviewer_amd64.deb
sudo apt install -f

cp /usr/share/applications/com.teamviewer.TeamViewer.desktop ~/Desktop
chmod +x ~/Desktop/com.teamviewer.TeamViewer.desktop
```
### Skype            
```sh
wget https://go.skype.com/skypeforlinux-64.deb

sudo dpkg -i skypeforlinux-64.deb

cp /usr/share/applications/skypeforlinux.desktop ~/Desktop
chmod +x ~/Desktop/skypeforlinux.desktop
```
### Spotify            
```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F9A211976ED662F00E59361E5E3C45D7B312C643

echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update

sudo apt install spotify-client
```
### Telegram        
```sh
wget --content-disposition https://telegram.org/dl/desktop/linux

xz -d tsetup.4.4.1.tar.xz
tar -xf tsetup.4.4.1.tar
sudo mv Telegram /opt
```
### Steam            
```sh
wget http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
sudo dpkg -i steam_latest.deb
```
### Java        
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/Java/jdk11.sh
chmod +x ./jdk11.sh.sh
./jdk11.sh.sh
```
### IntelliJ IDEA          
运行 `idea.sh` 脚本的时候，不要使用 `sudo` 命令，否则会提示无法找到JAVA运行环境。           
```sh
wget https://download-cdn.jetbrains.com/idea/ideaIC-2022.3.tar.gz
sudo tar -zxf ideaIC-2022.3.tar.gz -C /opt
/opt/ideaIC-2022.3/bin/idea.sh
```
IntelliJ IDEA 创建的启动文件，在 `~/.local/share/applications` 路径下。      
```sh
cp /usr/share/applications/jetbrains-idea.desktop ~/Desktop
chmod +x ~/Desktop/jetbrains-idea.desktop

rm ~/.local/share/applications/jetbrains-idea.desktop
```
### GoLand           
允许 `goland.sh` 脚本，安装 GoLand。            
```sh
wget https://download-cdn.jetbrains.com/go/goland-2022.3.tar.gz
sudo tar -zxf goland-2022.3.tar.gz -C /opt
/opt/GoLand-2022.3/bin/goland.sh
```
GoLand 默认不创建启动文件，第一次打开 GoLand 程序后，点击菜单栏上面的 Tool 创建桌面快捷方式。          
```sh
cp /usr/share/applications/jetbrains-goland.desktop ~/Desktop
chmod +x ~/Desktop/jetbrains-goland.desktop
```
![goland_img](/static/images/wiki/IMG_20190224_192100.png)          
![goland_img](/static/images/wiki/IMG_20190224_192101.png)
### 开启转发            
下面的命令都可以查询是否开启转发，0禁用，1启用               
```sh
sysctl net.ipv4.ip_forward

cat /proc/sys/net/ipv4/ip_forward
```
#### 临时生效的配置方式          
临时生效的配置方式，在系统重启，或对系统的网络服务进行重启后都会失效。这种方式可用于临时测试、或做实验时使用。                
`sysctl` 命令的 `-w` 参数可以实时修改Linux的内核参数，并生效。所以使用如下命令可以开发Linux的路由转发功能。                 
```sh
sysctl -w net.ipv4.ip_forward=1
```
内核参数在Linux文件系统中的映射出的文件：`/proc/sys/net/ipv4/ip_forward` 中记录了Linux系统当前对路由转发功能的支持情况。文件中的值为0,说明禁止进行IP转发；如果是`1`,则说明IP转发功能已经打开。可使用vi编辑器修改文件的内容，也可以使用如下指令修改文件内容：          
```sh
echo 1 > /proc/sys/net/ipv4/ip_forward
```
#### 永久生效的配置方式           
永久生效的配置方式，在系统重启、或对系统的网络服务进行重启后还会一直保持生效状态。这种方式可用于生产环境的部署搭建。              
在 `sysctl.conf` 配置文件中有一项名为 `net.ipv4.ip_forward` 的配置项，用于配置Linux内核中的 `net.ipv4.ip_forward`参数。其值为`0`,说明禁止进行IP转发；如果是`1`,则说明IP转发功能已经打开。        
需要注意的是，修改 `sysctl.conf` 文件后需要执行指令 `sysctl -p` 后新的配置才会生效。         
```sh
cat /etc/sysctl.conf | grep ip_forward
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
```
取消sysctl.conf文件中net.ipv4.ip_forward的注释              
```sh
sed -i '/net.ipv4.ip_forward/cnet.ipv4.ip_forward=1' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
cat /etc/sysctl.conf | grep ip_forward
```