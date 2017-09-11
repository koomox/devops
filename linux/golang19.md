# Go 1.9             
Go Home: [传送门](https://golang.org/)              
Go下载地址: [传送门](https://golang.org/dl/)             
golangtc 下载地址: [传送门](https://www.golangtc.com/download)               
### 二进制包安装 Go 1.9             
```sh
cd /tmp

wget https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz
tar -zxf go1.9.linux-amd64.tar.gz
mv go /usr/local/go
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
source /etc/profile

go env
go version
```