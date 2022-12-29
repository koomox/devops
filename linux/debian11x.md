# Debian 11.x             
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
echo "deb http://deb.debian.org/debian/ $(lsb_release -sc) main contrib non-free" > /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ $(lsb_release -sc) main contrib non-free" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ $(lsb_release -sc)-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ $(lsb_release -sc)-updates main contrib non-free" >> /etc/apt/sources.list
``` 
```sh
echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ $(lsb_release -sc) main contrib non-free" | sudo tee /etc/apt/sources.list
echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ $(lsb_release -sc) main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ $(lsb_release -sc)-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ $(lsb_release -sc)-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list
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
### Debian 11.x         
安装常用软件         
```sh
sudo apt install vim wget curl git gcc g++ make gdb build-essential htop iftop net-tools
```
启用 root 远程登录         
```sh
sudo sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sudo sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
```
一键设置优化 Amazon Lightsail [查看源文件](/storage/linux/debian/Lightsail/debian11x.sh)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/Lightsail/debian11x.sh
chmod +x ./debian11x.sh
./debian11x.sh
```
设置 iptables [查看源文件](/storage/linux/scripts/nftables/nftables.rules.sh)        
```sh
sudo wget -O custom_ssh_nftables.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nftables/nftables.rules.sh
sudo chmod +x ./custom_ssh_nftables.sh
sudo ./custom_ssh_nftables.sh
```
一键安装二进制版 Nginx 1.22.0 [查看源文件](/storage/linux/scripts/nginx/1.22.0/install.sh)          
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.22.0/install.sh
sudo chmod +x ./install.sh
sudo ./install.sh
```
配置文件      
```sh
sudo wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/default_force.conf
```
非 80、443 端口，安卓 Let's Encrypt 证书，可以使用 DNS 验证的方式, cloudflare 界面添加 txt 记录。        
```sh
sudo rm -rf /etc/letsencrypt/live
sudo mkdir -p /etc/letsencrypt/live && cd /etc/letsencrypt/live
sudo apt install -y certbot
sudo certbot certonly --manual --preferred-challenges dns -d example.com --register-unsafely-without-email
```
解压文件       
```sh
sudo apt-get install -y unzip
sudo mkdir -p /var/www/html
sudo cp -f html5up-editorial.unzip /var/www/html
sudo cd /var/www/html
sudo unzip html5up-editorial.zip
```
### youtube-dl      
安装 youtube-dl      
```sh
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/bin/youtube-dl
sudo chmod a+rx /usr/bin/youtube-dl
```
查看所能下载的所有格式:     
其中 `-F` 的 `F` 必须是大写，不能是小写的 `f` ，如果你写成小写，那就会报错。          
`youtube-dl -F` 或 `--list-formats` 视频地址          
输入该命令后，那在控制台上就会显示该视频地址所能下载到的所有格式。          
```sh
youtube-dl -F https://www.youtube.com/watch?v=xxxxx
youtube-dl --list-formats https://www.youtube.com/watch?v=xxxx
```
下载指定格式的文件:       
这里的 `-f` 只能是小写，不能是大写。        
下载它对应的质量最佳的视频以及质量最佳的音频以合成一个完整的视频       
```sh
youtube-dl -f bestvideo+bestaudio https://www.youtube.com/watch?v=xxxxxx
```
下载的视频文件名称有很多空格，在 Linux 系统中不好处理，我们将空格替换为下划线，使用下面的命令        
```sh
rename 's/ +/_/g' *
```