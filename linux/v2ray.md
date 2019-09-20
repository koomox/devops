# V2ray              
Home: [Link](https://www.v2ray.com/)              
github: [Link](https://github.com/v2ray/v2ray-core)           
安装文档: [Link](https://www.v2ray.com/chapter_00/install.html)            
### 安装        
V2Ray 提供了一个在 Linux 中的自动化安装脚本。这个脚本会自动检测有没有安装过 V2Ray，如果没有，则进行完整的安装和配置；如果之前安装过 V2Ray，则只更新 V2Ray 二进制程序而不更新配置。            

以下指令假设已在 `su` 环境下，如果不是，请先运行 `sudo su`。                

运行下面的指令下载并安装 V2Ray。当 `yum` 或 `apt-get` 可用的情况下，此脚本会自动安装 `unzip` 和 `daemon`。这两个组件是安装 V2Ray 的必要组件。如果你使用的系统不支持 `yum` 或 `apt-get`，请自行安装 `unzip` 和 `daemon`           
[查看源文件](https://github.com/v2ray/v2ray-core/blob/master/release/install-release.sh)            
```sh
bash <(curl -L -s https://install.direct/go.sh)

bash <(curl -L -s https://raw.githubusercontent.com/v2ray/v2ray-core/master/release/install-release.sh)
```
此脚本会自动安装以下文件：          
 * /usr/bin/v2ray/v2ray：V2Ray 程序；
 * /usr/bin/v2ray/v2ctl：V2Ray 工具；
 * /etc/v2ray/config.json：配置文件；
 * /usr/bin/v2ray/geoip.dat：IP 数据文件
 * /usr/bin/v2ray/geosite.dat：域名数据文件        

### Nginx            
```sh
mkdir -p /etc/nginx/conf.d
wget -O /etc/nginx/conf.d/default.conf 
```