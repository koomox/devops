# Node.js              
### 一键安装 LTS Node.js            
Linux 一键安装 Node.js，自动检测系统类型，安装最新稳定版 Node.js。          
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nodejs/lts_nodejs.sh
chmod +x ./lts_nodejs.sh
./lts_nodejs.sh
```
### 一键安装最新发行版 Node.js            
Linux 一键安装 Node.js，自动检测系统类型，安装最新发行版 Node.js。          
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nodejs/lts_nodejs.sh
chmod +x ./lts_nodejs.sh
./lts_nodejs.sh
```
中国用户使用该版本从 `https://github.com/nodejs/node/tags` 页面提取最新版本号，自动安装，设置环境变量。         
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nodejs/latest_nodejs_v2.sh
chmod +x ./latest_nodejs_v2.sh
./latest_nodejs_v2.sh
```