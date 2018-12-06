# IntelliJ IDEA License Server           
IntelliJ IDEA License Server: [传送门](http://idea.lanyus.com/)        
下载地址: [传送门](http://blog.lanyus.com/archives/174.html)       
在线生成注册码：[传送门1](http://idea.iteblog.com/)   [传送门2](http://idea.lanyus.com/)    
用户名必须是电脑用户名即可。              

IntelliJ IDEA License Server 默认使用的是 `1017` 端口（v1.6版修改为`1027`），也有 `41017` 端口版本。           
在idea注册界面选择授权服务器，填写`http://127.0.0.1:1027`，然后点击“OK”            
```
http://127.0.0.1:1027
```
使用前请将`0.0.0.0 account.jetbrains.com`添加到hosts文件中          
```
0.0.0.0 account.jetbrains.com
```
### 启用端口         
```sh
firewall-cmd --permanent --zone=public --add-port=1027/tcp
firewall-cmd --reload
```
```sh
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 1027 -j ACCEPT
```
### 一键安装脚本        
Debian 9.x 一键安装脚本         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/IntelliJIDEALicenseServer/debian_idea.sh
chmod +x ./debian_idea.sh
./debian_idea.sh
```
树莓派 Raspbian 一键安装脚本           
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/IntelliJIDEALicenseServer/raspbian_idea.sh
chmod +x ./raspbian_idea.sh
./raspbian_idea.sh
```