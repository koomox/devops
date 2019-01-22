# 安装 Golang                    
Go Home: [传送门](https://golang.org/)              
Go 下载地址: [传送门](https://golang.org/dl/)             
Go 下载地址:[中国镜像](https://golang.google.cn/)            
github 仓库: [传送门](https://github.com/golang/go/)              
### Linux 一键安装最新版 Golang                
从 `https://golang.org/dl/` 页面提取最新版本号，自动安装，设置环境变量。                
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/go/latest_go.sh
chmod +x ./latest_go_v2.sh
./latest_go.sh
```
从 `https://golang.org/` 页面提取最新版本号，自动安装，设置环境变量。                     
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/go/latest_go_v2.sh
chmod +x ./latest_go_v2.sh
./latest_go_v2.sh
```
中国用户使用该版本从 `https://github.com/golang/go/tags` 页面提取最新版本号，自动安装，设置环境变量。                     
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/go/latest_go_v3.sh
chmod +x ./latest_go_v3.sh
./latest_go_v3.sh
```