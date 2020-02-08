# FFpemg 搭建流媒体服务器            
### 安装         
```sh
sudo apt update -y
sudo apt upgrade -y

sudo apt-get install ffmpeg -y
```
备份并设置配置文件           
```sh
cp -f /etc/ffserver.conf /etc/ffserver.conf.bak
sed -i '/^#/d;/^$/d;/^;/d' /etc/ffserver.conf
```
启动 ffserver, 访问 `http://localhost:8090/stat.html`              
```sh
nohup ffserver -f /etc/ffserver.conf &
```
### Nginx          
```sh
sudo apt-get install build-essential libpcre3 libpcre3-dev libssl-dev git zlib1g-dev -y
```
```sh
wget https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.tar.gz
wget https://www.zlib.net/zlib-1.2.11.tar.gz
wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz
wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz
wget https://nginx.org/download/nginx-1.16.1.tar.gz

tar -zxf v1.2.1.tar.gz
tar -zxf zlib-1.2.11.tar.gz
tar -zxf pcre-8.43.tar.gz
tar -zxf openssl-1.1.1d.tar.gz
tar -zxf nginx-1.16.1.tar.gz

cd nginx-1.16.1
./configure --prefix=/usr/local/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/lib/nginx/nginx.pid \
--lock-path=/var/lib/nginx/nginx.lock \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_sub_module \
--with-http_gzip_static_module \
--with-http_slice_module \
--with-http_stub_status_module \
--with-stream \
--with-stream_ssl_module \
--with-pcre=../pcre-8.43 \
--with-zlib=../zlib-1.2.11 \
--with-openssl=../openssl-1.1.1d \
--add-module=../nginx-rtmp-module-1.2.1
make
make install
```