# Shadowsocks             
一键打包下载 shadowsocks-go 并上传至 firefox send             
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/download_shadowsocks_go.sh
chmod +x ./download_shadowsocks_go.sh
./download_shadowsocks_go.sh
```
一键打包下载 go-shadowsocks2 并上传至 firefox send         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/download_go_shadowsocks2.sh
chmod +x ./download_go_shadowsocks2.sh
./download_go_shadowsocks2.sh
```
一键打包下载 shadowsocks-libev 并上传至 firefox send         
```sh
wget -O download_shadowsocks_libev.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/download_shadowsocks_libev.sh
chmod +x ./download_shadowsocks_libev.sh
./download_shadowsocks_libev.sh
```
一键配置ss-local             
```sh
wget -O debian9x_ss_local.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian9x_ss_local.sh
chmod +x ./debian9x_ss_local.sh
./debian9x_ss_local.sh
```
一键配置ss-redir        
```sh
wget -O debian9x_ss_redir.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian9x_ss_redir.sh
chmod +x ./debian9x_ss_redir.sh
./debian9x_ss_redir.sh
```
一键配置ss-tunnel        
```sh
wget -O debian9x_ss_tunnel.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian9x_ss_tunnel.sh
chmod +x ./debian9x_ss_tunnel.sh
./debian9x_ss_tunnel.sh
```