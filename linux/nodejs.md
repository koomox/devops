# Node.js              
Node.js Home: [传送门](https://nodejs.org/en/)              
Node.js 下载页面: [传送门](https://nodejs.org/en/download/)             
Node.js 下载仓库: [传送门](https://nodejs.org/dist/)          
github 仓库:[传送门](https://github.com/nodejs/node)                    
### 一键安装 LTS Node.js            
Linux 一键安装 Node.js，自动检测系统类型，安装最新稳定版 Node.js。[查看源文件](/storage/linux/scripts/nodejs/lts_nodejs.sh)          
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nodejs/lts_nodejs.sh
chmod +x ./lts_nodejs.sh
./lts_nodejs.sh
```
### 一键安装最新发行版 Node.js            
Linux 一键安装 Node.js，自动检测系统类型，安装最新发行版 Node.js。[查看源文件](/storage/linux/scripts/nodejs/latest_nodejs.sh)          
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nodejs/latest_nodejs.sh
chmod +x ./latest_nodejs.sh
./latest_nodejs.sh
```
中国用户使用该版本从 `https://github.com/nodejs/node/tags` 页面提取最新版本号，自动安装，设置环境变量。 [查看源文件](/storage/linux/scripts/nodejs/latest_nodejs_v2.sh)        
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nodejs/latest_nodejs_v2.sh
chmod +x ./latest_nodejs_v2.sh
./latest_nodejs_v2.sh
```
### NodeSource           
github: [Link](https://github.com/nodesource/distributions)         
```sh
wget -qO- https://deb.nodesource.com/setup_10.x | bash -
```
```sh
curl -sL https://deb.nodesource.com/setup_11.x | bash -
```
```sh
wget -qO- https://deb.nodesource.com/setup_12.x | bash -
```
更新系统并安装 `nodejs` `yarn`         
```sh
apt update -y
apt install nodejs -y
apt install yarn -y
```
### NPM       
设置代理         
```sh
npm config set proxy http://127.0.0.1:8080
npm config set https-proxy http://127.0.0.1:8080
```
查看代理        
```sh
npm config get
npm config list
```
删除代理       
```sh
npm config delete proxy
npm config delete https-proxy
```

### Yarn         
Windows Classic Stable: [Link](https://classic.yarnpkg.com/en/docs/install/#windows-stable)         
安装 yarn         
```sh
npm install --global yarn

yarn --version
```
设置代理         
```sh
yarn config set proxy http://127.0.0.1:8080
yarn config set https-proxy http://127.0.0.1:8080
```
查看代理        
```sh
yarn config get
yarn config list
```
删除代理       
```sh
yarn config delete proxy
yarn config delete https-proxy
```
