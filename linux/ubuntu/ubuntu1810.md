# Ubuntu 18.10          
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
### 更换更新源            
```sh
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo wget -O /etc/apt/sources.list https://gitee.com/koomox/devops/raw/master/storage/linux/ubuntu/sources/ubuntu1810.tuna.sources.list
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
### 添加代理          
国内下载软件的时候非常慢，可以使用代理加速下载，下面的方法重启电脑后即失效。（对apt、wget、等命令有效）                      
```sh
export http_proxy="http://127.0.0.1:8080"
```
### 安装输入法            
```sh
sudo apt install fcitx fcitx-googlepinyin
```
配置文件        
```sh
echo -e "export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS=\"@im=fcitx\"" >> ~/.xprofile
```
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
```
### Spotify            
```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90

echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update

sudo apt install spotify-client
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
wget https://download.jetbrains.8686c.com/idea/ideaIU-2018.3.4-no-jdk.tar.gz
sudo tar -zxf ideaIU-2018.3.4-no-jdk.tar.gz -C /opt
/opt/idea-IU-183.5429.30/bin/idea.sh
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
wget https://download.jetbrains.8686c.com/go/goland-2018.3.4.tar.gz
sudo tar -zxf goland-2018.3.4.tar.gz -C /opt
/opt/GoLand-2018.3.4/bin/goland.sh
```
GoLand 默认不创建启动文件，第一次打开 GoLand 程序后，点击菜单栏上面的 Tool 创建桌面快捷方式。          
```sh
cp /usr/share/applications/jetbrains-goland.desktop ~/Desktop
chmod +x ~/Desktop/jetbrains-goland.desktop
```
![goland_img](https://raw.githubusercontent.com/koomox/devops/master/static/images/wiki/IMG_20190224_192100.png)          
![goland_img](https://raw.githubusercontent.com/koomox/devops/master/static/images/wiki/IMG_20190224_192101.png)