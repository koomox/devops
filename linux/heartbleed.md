# 修复 OpenSSL 心脏出血漏洞Heartbleed                
OpenSSL出现HeartBleed心脏出血漏洞               
OpenSSL 1.0.1f及以下的版本受该漏洞的影响               
OpenSSL 1.0.1g及以上的版本不受影响               
所以我们需要升级系统的OpenSSL               
OpenSSL 下载地址: [传送门](https://www.openssl.org/source/)           
OpenSSL github.com: [传送门](https://github.com/openssl/openssl)            

### OpenSSL             
安装依赖包           
```sh
yum -y install gcc gcc-c++ make automake autoconf perl zlib-devel
```
删除 OpenSSL 旧版本文件            
```sh
\rm -rf /usr/local/openssl
\rm -rf /usr/bin/openssl /usr/include/openssl
```
安装 OpenSSL 1.0.2l              
```sh
cd /tmp

\rm -rf openssl-1.0.2l.tar.gz
wget https://www.openssl.org/source/openssl-1.0.2l.tar.gz

\rm -rf openssl-1.0.2l
tar -zxf openssl-1.0.2l.tar.gz
cd openssl-1.0.2l
./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib
make && make install

ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl/include/openssl /usr/include/openssl

touch /etc/ld.so.conf.d/openssl.conf
echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl.conf
ldconfig -v
openssl version -a
```      
查看 OpenSSL 1.0.2l openssl.conf [源文件](../storage/linux/scripts/openssl/1.0.2l/openssl.cnf)             
```sh
\rm -rf /etc/pki/tls/misc /etc/pki/tls/openssl.cnf
ln -s /usr/local/openssl/misc /etc/pki/tls/misc
wget -O /etc/pki/tls/openssl.cnf https://git.oschina.net/koomox/devops/raw/master/storage/linux/scripts/openssl/1.0.2l/openssl-ca.cnf

wget -O /etc/pki/tls/openssl.cnf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/openssl/1.0.2l/openssl-ca.cnf
```
```sh
\rm -rf /etc/pki/tls/openssl.cnf

wget -O /etc/pki/tls/openssl.cnf https://git.oschina.net/koomox/devops/raw/master/storage/linux/scripts/openssl/1.0.2l/openssl-cert.cnf

wget -O /etc/pki/tls/openssl.cnf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/openssl/1.0.2l/openssl-cert.cnf
```