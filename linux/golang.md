# 安装 Golang                    
Golang [Home Link](https://golang.org/)      
GoLand [Link](https://www.jetbrains.com/go/)          
Heroku [Link](https://www.heroku.com/go)          
### Environment Variables           
```sh
export GOPROXY=https://goproxy.io,direct
```
```sh
echo -e 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
```
### Linux 一键安装最新版 Golang                
get linux amd64 version                
```sh
GO_VERSION=$(wget -qO- --no-check-certificate https://go.dev/dl/ | grep -m1 -E "go([0-9]+\.){0,3}linux-amd64.tar.gz" | sed -E "s/.*(go.*linux-amd64.tar.gz).*/\1/gm" )
```
```sh
GO_VERSION=$(wget -qO- --no-check-certificate https://github.com/golang/go/tags | grep -m1 -E "/releases/tag/go[0-9]+\.[0-9]+\.[0-9]+" | sed -E "s/.*(go[0-9]+\.[0-9]+\.[0-9]+).*/\1.linux-amd64.tar.gz/gm")
```
get linux arm64 version       
```sh
GO_VERSION=$(wget -qO- --no-check-certificate https://go.dev/dl/ | grep -m1 -E "go([0-9]+\.){0,3}linux-arm64.tar.gz" | sed -E "s/.*(go.*linux-arm64.tar.gz).*/\1/gm" )
```
下载解压安装          
```sh
wget -O ${GO_VERSION}.tar.gz https://dl.google.com/go/${GO_VERSION}.tar.gz
sudo tar -C /usr/local -xzf  ${GO_VERSION}.tar.gz
```
### 打包带图标的 windows 可执行程序            
下载 `rsrc`
```sh
go get github.com/akavel/rsrc
go build github.com/akavel/rsrc
```
创建 `main.manifest` 文件       
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
    <assemblyIdentity version="1.0.0.0" processorArchitecture="*" name="controls" type="win32">
	</assemblyIdentity>
    <dependency>
        <dependentAssembly>
            <assemblyIdentity type="win32" name="Microsoft.Windows.Common-Controls" version="6.0.0.0" processorArchitecture="*" publicKeyToken="6595b64144ccf1df" language="*">
			</assemblyIdentity>
        </dependentAssembly>
    </dependency>
</assembly>
```
生成 `syso` 文件          
```sh
rsrc -manifest main.manifest -ico main.ico -o main.syso
```
编译程序        
```sh
go build -ldflags "-s -w" -o app.exe
```
### Alpine Linux       
linux上面运行`cgo`需要`musl-dev`依赖包         
```sh
apk add --no-cache musl-dev
```
由于alpine镜像使用的是musl libc而不是gnu libc，/lib64/ 是不存在的。但他们是兼容的，可以创建个软连接过去试试。          
```sh
mkdir /lib64
ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
go version
```