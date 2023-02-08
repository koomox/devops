# WireGuard             
Home [Link](https://www.wireguard.com/)          
### install        
```sh
sudo apt install wireguard-tools
```
### cloudflare warp           
```sh
curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
```
```sh
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
```
```sh
sudo apt update

sudo apt upgrade
```
```sh
echo "Cloudflare WARP Account Registration in progress..."
warp-cli --accept-tos register

echo "Setting up WARP Proxy Mode..."
warp-cli --accept-tos set-mode proxy

echo "Connecting to WARP..."
warp-cli --accept-tos connect

echo "Enable WARP Always-On..."
warp-cli --accept-tos enable-always-on

echo "Status check in progress..."
warip-cli status
```
