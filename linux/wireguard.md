# WireGuard             
Home [Link](https://www.wireguard.com/)          
### install        
```sh
sudo apt install wireguard
```
warp PublicKey        
```
[Interface]
PrivateKey = xxxxxxxxxxxxxxxxxx
Address = 172.16.0.2/32
Address = 2606:4700:110:8d44:a7a8:52e5:a5e:c043/128
DNS = 1.1.1.1,8.8.8.8
MTU = 1280
[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = 0.0.0.0/0
AllowedIPs = ::/0
Endpoint = engage.cloudflareclient.com:2408
```
Endpoint IPv4 range:       
```
162.159.193.1 - 162.159.193.10
162.159.192.0 - 162.159.192.254
162.159.195.0 - 162.159.195.254
```
Endpoint Port range:  2408, 1701, 500, 4500, 908           
### cloudflare warp           
一键安装 cloudflare warp [source](/storage/linux/debian/Lightsail/warp.sh)       
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/Lightsail/warp.sh
chmod +x ./warp.sh
./warp.sh
```
reset warp ip address       
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/Lightsail/reset_warp.sh
chmod +x ./reset_warp.sh
./reset_warp.sh
```
```sh
curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
```
```sh
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
```
```sh
sudo apt update

sudo apt upgrade

sudo apt install cloudflare-warp

sudo systemctl status warp-svc
```
```sh
echo "Cloudflare WARP Account Registration in progress..."
warp-cli --accept-tos register

echo "Setting up WARP Proxy Mode..."
warp-cli --accept-tos set-mode proxy

echo "Setting up WARP Proxy Socks5 Port..."
warp-cli --accept-tos set-proxy-port 1080

echo "check WARP Proxy Setting..."
warp-cli settings

echo "Connecting to WARP..."
warp-cli --accept-tos connect

echo "Enable WARP Always-On..."
warp-cli --accept-tos enable-always-on

echo "Status check in progress..."
warp-cli warp-stats
```
```sh
curl https://checkip.amazonaws.com/

curl -x socks5://127.0.0.1:1080  https://checkip.amazonaws.com/

curl -x socks5://127.0.0.1:1080 https://www.cloudflare.com/cdn-cgi/trace/
```
check register info          
```sh
sudo cat /var/lib/cloudflare-warp/reg.json /var/lib/cloudflare-warp/conf.json
```