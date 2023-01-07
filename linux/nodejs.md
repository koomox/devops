# Node.js              
Node.js Home: [传送门](https://nodejs.org/en/)              
Node.js 下载页面: [传送门](https://nodejs.org/en/download/)             
Node.js 下载仓库: [传送门](https://nodejs.org/dist/)          
github 仓库:[传送门](https://github.com/nodejs/node)                    
### 一键安装 LTS Node.js            
get latest version number             
```sh
NODE_VERSION=$(wget -qO- --no-check-certificate https://nodejs.org/en/download/ | grep -m1 -E "Latest LTS Version" | sed -E "s/.*>([0-9]+\.[0-9]+\.*[0-9])<.*/\1/gm")
```
```sh
NODE_VERSION=$(wget -qO- --no-check-certificate https://github.com/nodejs/node/tags | grep -m1 -E "/releases/tag/v[0-9]+\.[0-9]+\.[0-9]+" | sed -E "s/.*v([0-9]+\.[0-9]+\.[0-9]+).*/\1/gm")
```
download and Extract file               
```sh
wget -O https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz

mkdir -p /usr/local/node
xz -d node-v${NODE_VERSION}-linux-x64.tar.xz
tar --strip-components 1 -C /usr/local/node -xf node-v${NODE_VERSION}-linux-x64.tar
```
Environment
```sh
echo 'export NODE_HOME=/usr/local/node' >> /etc/profile
echo 'export PATH=$PATH:$NODE_HOME/bin' >> /etc/profile
echo 'export NODE_PATH=$PATH:$NODE_HOME/lib/node_modules' >> /etc/profile
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
sudo apt-get update -y
sudo apt-get install nodejs -y
sudo apt-get install yarn -y
```
### NPM       
设置代理         
```sh
npm config set proxy http://127.0.0.1:1080
npm config set https-proxy http://127.0.0.1:1080
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
Windows Classic Stable: [Link](https://classic.yarnpkg.com/en/docs/install/#windows-stable)  [Download](https://classic.yarnpkg.com/latest.msi)        
安装 yarn         
```sh
npm install --global yarn

yarn --version
```
设置代理         
```sh
yarn config set proxy http://127.0.0.1:1080
yarn config set https-proxy http://127.0.0.1:1080
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
