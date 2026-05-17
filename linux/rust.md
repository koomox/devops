# Rust           
Rust Home: [Link](https://www.rust-lang.org/)             
github: [Link](https://github.com/rust-lang/rust)          
Rust 安装文档And下载地址: [Link](https://forge.rust-lang.org/other-installation-methods.html)           
Rust 安装方法: [Link](https://doc.rust-lang.org/1.0.0/book/installing-rust.html)            
rustup: [Link](https://rustup.rs/)        
### 在线安装 Rust           
```sh
curl https://sh.rustup.rs -sSf | sh
# 1) Proceed with installation (default)
# 2) Customize installation
# 3) Cancel installation
# >1

source ~/.profile
source ~/.cargo/env

rustc --version
```
### 二进制包安装 Rust          
树莓派安装 Rust        
```sh
wget https://static.rust-lang.org/dist/rust-1.37.0-armv7-unknown-linux-gnueabihf.tar.gz
tar -zxf rust-1.37.0-armv7-unknown-linux-gnueabihf.tar.gz
cd rust-1.37.0-armv7-unknown-linux-gnueabihf
./install.sh

rustc --version
```
Debian 安装 Rust       
```sh
wget https://static.rust-lang.org/dist/rust-1.37.0-x86_64-unknown-linux-gnu.tar.gz
tar -zxf rust-1.37.0-x86_64-unknown-linux-gnu.tar.gz
cd rust-1.37.0-x86_64-unknown-linux-gnu
./install.sh

rustc --version
```
### Linux 安装 ffsend         
ffsend Home: [Link](https://github.com/timvisee/ffsend)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/ffsend/ffsend.sh
chmod +x ./ffsend.sh
./ffsend.sh

ffsend --version
```