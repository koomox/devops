# Shadowsocks             
github: [Link](https://github.com/shadowsocks/shadowsocks-libev)        
### Debian 10.x 安装 shadowsocks        
安装依赖包          
```sh
sudo apt-get install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev
```
安装 `Libsodium`            
```sh
export LIBSODIUM_VER=1.0.16
wget https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
tar xvf libsodium-$LIBSODIUM_VER.tar.gz
cd libsodium-$LIBSODIUM_VER
./configure --prefix=/usr && make
sudo make install
cd ..
sudo ldconfig
```
安装 `MbedTLS`        
```sh
export MBEDTLS_VER=2.6.0
wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
cd mbedtls-$MBEDTLS_VER
make SHARED=1 CFLAGS="-O2 -fPIC"
sudo make DESTDIR=/usr install
cd ..
sudo ldconfig
```
安装 shadowsocks-libev        
```sh
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
cd ..
./autogen.sh
./configure --prefix=/usr --disable-documentation && make
sudo make install
```
systemd 启动文件 [Link](/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian/shadowsocks-libev-server@.service)         
```sh
wget -O /etc/systemd/system/shadowsocks-libev-server@.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian/shadowsocks-libev-server@.service
systemctl enable shadowsocks-libev-server@server
systemctl start shadowsocks-libev-server@server
systemctl status shadowsocks-libev-server@server
```
配置文件 `/etc/shadowsocks-libev/server.json` [source file](/storage/linux/scripts/shadowsocks/server-config.json)       
```sh
mkdir -p /etc/shadowsocks-libev && cd /etc/shadowsocks-libev
wget -O /etc/shadowsocks-libev/server.json https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/server-config.json

server_ip=0.0.0.0
server_port=10000
password=
method=aes-256-gcm
sed -i "s/my-server-ip/${server_ip}/g" /etc/shadowsocks-libev/server.json
sed -i "s/8888/${server_port}/g" /etc/shadowsocks-libev/server.json
sed -i "s/mypassword/${password}/g" /etc/shadowsocks-libev/server.json
sed -i "s/aes-256-cfb/${method}/g" /etc/shadowsocks-libev/server.json

cat /etc/shadowsocks-libev/server.json
```
一键打包下载 shadowsocks-go 并上传至 firefox send [source file](/storage/linux/scripts/shadowsocks/download_shadowsocks_go.sh)            
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/download_shadowsocks_go.sh
chmod +x ./download_shadowsocks_go.sh
./download_shadowsocks_go.sh
```
一键打包下载 go-shadowsocks2 并上传至 firefox send [source file](/storage/linux/scripts/shadowsocks/download_go_shadowsocks2.sh)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/download_go_shadowsocks2.sh
chmod +x ./download_go_shadowsocks2.sh
./download_go_shadowsocks2.sh
```
一键打包下载 shadowsocks-libev 并上传至 firefox send [source file](/storage/linux/scripts/shadowsocks/download_shadowsocks_libev.sh)         
```sh
wget -O download_shadowsocks_libev.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/download_shadowsocks_libev.sh
chmod +x ./download_shadowsocks_libev.sh
./download_shadowsocks_libev.sh
```
一键配置ss-local [source file](/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian9x_ss_local.sh)            
```sh
wget -O debian9x_ss_local.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian9x_ss_local.sh
chmod +x ./debian9x_ss_local.sh
./debian9x_ss_local.sh
```
一键配置ss-redir [source file](/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian9x_ss_redir.sh)        
```sh
wget -O debian9x_ss_redir.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian9x_ss_redir.sh
chmod +x ./debian9x_ss_redir.sh
./debian9x_ss_redir.sh
```
一键配置ss-tunnel [source file](/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian9x_ss_tunnel.sh)       
```sh
wget -O debian9x_ss_tunnel.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian9x_ss_tunnel.sh
chmod +x ./debian9x_ss_tunnel.sh
./debian9x_ss_tunnel.sh
```