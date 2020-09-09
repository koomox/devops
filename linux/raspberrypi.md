# Raspberry Pi                 
#### Open SSH          
Raspbian 的 SSH 默认是不随开机自动启动的，使用如下命令后，还是不能开机启动，在 `/boot` 目录下创建 `SSH` 文件后就能随开机自动启动了。         
```sh
touch /boot/ssh
sudo systemctl start ssh
sudo systemctl status ssh
```
Raspbian 重启后，无法使用SSH链接，将以下代码加入 `/etc/rc.local` 文件。          
```sh
if [ ! -f /boot/ssh ]; then
	touch /boot/ssh
fi
```
#### 更换源            
Debian 默认只支持HTTP源，若要使用HTTPS源，需要安装 `apt-transport-https`         
```sh
sudo apt install apt-transport-https
sudo apt update
```
```sh
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cp /etc/apt/sources.list.d/raspi.list /etc/apt/sources.list.d/raspi.list.bak

sudo sed -E -i 's/(http|https):\/\/.*\/raspbian\//https:\/\/mirrors.tuna.tsinghua.edu.cn\/raspbian\/raspbian\//g' /etc/apt/sources.list
sudo sed -E -i 's/(http|https):\/\/.*\/debian\//https:\/\/mirrors.tuna.tsinghua.edu.cn\/raspberrypi\//g' /etc/apt/sources.list.d/raspi.list

sudo cat /etc/apt/sources.list /etc/apt/sources.list.d/raspi.list
```
安装常用软件        
```sh
sudo apt install vim curl wget git screen htop build-essential lsb-release
```
#### Open VNC Server            
```sh
sudo raspi-config
```
![](/static/images/wiki/IMG_20200909_013700.png)       
![](/static/images/wiki/IMG_20200909_013701.png)            

Putty: [Link](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)             
Xshell: [Link](https://www.netsarang.com/en/free-for-home-school/)           
### 设置分辨率            
```sh
sudo raspi-config
```
![](/static/images/wiki/IMG_20200909_014400.png)       
![](/static/images/wiki/IMG_20200909_014401.png)            
![](/static/images/wiki/IMG_20200909_014402.png)       
#### VSCode         
```sh
sudo wget -qO - https://packagecloud.io/headmelted/codebuilds/gpgkey | sudo apt-key add -
wget --content-disposition https://packagecloud.io/headmelted/codebuilds/packages/debian/stretch/code-oss_1.45.0-1586135927_armhf.deb/download.deb
sudo apt install ./code-oss_1.45.0-1586135927_armhf.deb
```
#### Python         
```sh
sudo apt install python python-pip
sudo apt install python3 python3-pip
python --version
python3 --version
python -m pip --version
pip3 --version
```
```sh
python -m pip list --format=columns
```