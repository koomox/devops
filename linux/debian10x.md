# Debian 10.x              
一键设置优化 Amazon Lightsail [查看源文件](/storage/linux/debian/Lightsail/debian10x.sh)         
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/Lightsail/debian10x.sh
sudo chmod +x ./debian10x.sh
sudo ./debian10x.sh
```
一键设置优化 Aliyun ECS [查看源文件](/storage/linux/debian/Aliyun/debian10x.sh)        
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/Aliyun/debian10x.sh
sudo chmod +x ./debian10x.sh
sudo ./debian10x.sh
```
设置 iptables [查看源文件](/storage/linux/scripts/iptables/iptables.v2.rules.sh)        
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/iptables/iptables.v2.rules.sh
sudo chmod +x ./iptables.v2.rules.sh
sudo ./iptables.v2.rules.sh
```
一键安装二进制版 Nginx 1.18.0 [查看源文件](/storage/linux/scripts/nginx/1.18.0/install.sh)          
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.18.0/install.sh
sudo chmod +x ./install.sh
sudo ./install.sh
```
### youtube-dl      
安装 youtube-dl      
```sh
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/bin/youtube-dl
sudo chmod a+rx /usr/bin/youtube-dl

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