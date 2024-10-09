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
### 用法          
使用 OBS Studio 录制得视频为 MKV 格式，无法导入 Premiere Pro, 使用 ffmpeg 转换为 MP4 格式, `-ss` 开始时间, `-t` 要切割得时间, `-i` 源文件                     
```sh
ffmpeg -ss 00:00:00 -t 00:10:00 -i input.mkv -vcodec copy -acodec copy output.mp4
```
提取视频           
```sh
ffmpeg -i input.mkv -vcodec copy -an output.mp4
```
提取音频        
```sh
ffmpeg -i input.mkv -acodec aac -vn ouput.aac
```
码率控制, 可以压缩文件得大小          
```sh
ffmpeg -i input.mp4 -b:v 2000k -bufsize 2000k output.mp4
ffmpeg -i input.mp4 -b:v 4000k -bufsize 4000k output.mp4
```
为视频添加 LOGO 图片       
```sh
ffmpeg -i input.mp4 -i logo.png -filter_complex overlay output.mp4
```
