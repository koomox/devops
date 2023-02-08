# WireGuard             
Home [Link](https://www.wireguard.com/)          
### install        
```sh
sudo apt install wireguard-tools
```
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
```