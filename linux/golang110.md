# Go 1.10             
Go Home: [传送门](https://golang.org/)              
Go下载地址: [传送门](https://golang.org/dl/)             
Go 下载地址:[中国镜像](https://golang.google.cn/)            
golangtc 下载地址: [传送门](https://www.golangtc.com/download)               
### 二进制包安装 Go 1.10             
```sh
cd /tmp

curl -LO https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
source /etc/profile

go env
go version
```