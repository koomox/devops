# Debian 11.x              
一键设置优化 Amazon Lightsail [查看源文件](/storage/linux/debian/Lightsail/debian11x.sh)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/Lightsail/debian11x.sh
chmod +x ./debian11x.sh
./debian11x.sh
```
设置 iptables [查看源文件](/storage/linux/scripts/nftables/nftables.rules.sh)        
```sh
wget -O custom_ssh_nftables.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nftables/nftables.rules.sh
chmod +x ./custom_ssh_nftables.sh
./custom_ssh_nftables.sh
```
一键安装二进制版 Nginx 1.20.2 [查看源文件](/storage/linux/scripts/nginx/1.20.2/install.sh)          
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.20.2/install.sh
chmod +x ./install.sh
./install.sh
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