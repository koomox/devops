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
sudo apt install apt-transport-https ca-certificates software-properties-common

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
### Telegram           
使用二进制安装包安装最新版 Telegram-desktop，安装后在终端中执行 `telegram-desktop` 会自动创建应用程序图标。             
```sh
wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/
cd /opt/Telegram
sudo mkdir -p /usr/local/telegram-desktop/bin
sudo mv Telegram Updater -t /usr/local/telegram-desktop/bin
echo 'export PATH=$PATH:/usr/local/telegram-desktop/bin' >> /etc/profile
source /etc/profile
```
一键安装 Telegram-desktop 最新版         
```sh
curl -s https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/telegram/latest_telegram_desktop_v3.sh -o /tmp/latest_telegram_desktop_v3.sh
chmod +x /tmp/latest_telegram_desktop_v3.sh
/tmp/latest_telegram_desktop_v3.sh
```