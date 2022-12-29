# 安装 Golang                    
Golang [Home Link](https://golang.org/)      
GoLand [Link](https://www.jetbrains.com/go/)          
Heroku [Link](https://www.heroku.com/go)          
### Environment Variables           
```sh
export GOPROXY=https://goproxy.io,direct
```
```sh
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
```
### Linux 一键安装最新版 Golang                
从 `https://golang.org/dl/` 页面提取最新版本号，自动安装，设置环境变量。[查看源文件](/storage/linux/scripts/go/latest_go.sh)                
```sh
GO_BITS=amd64
GO_VERSION=$(wget -q -O - https://golang.org/dl/ | grep -m1 -E "go[0-9]+\.[0-9]+\.*[0-9]*\.linux.*\.tar\.gz" | sed -E "s/.*go([0-9]+\.[0-9]+\.*[0-9]*)\.linux.*\.tar\.gz.*/\1/gm")
wget -O go${GO_VERSION}.linux-${GO_BITS}.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-${GO_BITS}.tar.gz
tar -C /usr/local -xzf  go${GO_VERSION}.linux-${GO_BITS}.tar.gz
```
从 `https://golang.org/` 页面提取最新版本号，自动安装，设置环境变量。[查看源文件](/storage/linux/scripts/go/latest_go_v2.sh)                     
```sh
GO_BITS=amd64
GO_VERSION=$(wget -q -O - https://golang.org/ | grep -E "goVersion" | sed -E "s/.*go([0-9]+\.[0-9]+\.*[0-9]*).*/\1/gm")
wget -O go${GO_VERSION}.linux-${GO_BITS}.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-${GO_BITS}.tar.gz
tar -C /usr/local -xzf  go${GO_VERSION}.linux-${GO_BITS}.tar.gz
```
中国用户使用该版本从 `https://github.com/golang/go/tags` 页面提取最新版本号，自动安装，设置环境变量。[查看源文件](/storage/linux/scripts/go/latest_go_v3.sh)                     
```sh
GO_BITS=amd64
GO_VERSION=$(wget -q -O - https://github.com/golang/go/tags | grep -v "beta" | grep -m1 -E "golang/go/releases/tag/go[0-9]+\.[0-9]+\.*[0-9]*" | sed -E "s/.*go([0-9]+\.[0-9]+\.*[0-9]*).*/\1/gm")
wget -O go${GO_VERSION}.linux-${GO_BITS}.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-${GO_BITS}.tar.gz
tar -C /usr/local -xzf  go${GO_VERSION}.linux-${GO_BITS}.tar.gz
```
安装 arm 版本 golang          
```sh
GO_BITS=arm64
GO_VERSION=$(wget -q -O - https://golang.org/dl/ | grep -m1 -E "go[0-9]+\.[0-9]+\.*[0-9]*\.linux.*\.tar\.gz" | sed -E "s/.*go([0-9]+\.[0-9]+\.*[0-9]*)\.linux.*\.tar\.gz.*/\1/gm")
wget -O go${GO_VERSION}.linux-${GO_BITS}.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-${GO_BITS}.tar.gz
tar -C /usr/local -xzf  go${GO_VERSION}.linux-${GO_BITS}.tar.gz
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