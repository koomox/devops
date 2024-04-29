# WireGuard             
Home [Link](https://www.wireguard.com/)          
### install        
```sh
sudo apt install wireguard
```
```sh
wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey

cat /etc/wireguard/privatekey /etc/wireguard/publickey
```
```sh
sudo vim /etc/wireguard/wg0.conf
```
```
[Interface]
Address = 192.168.10.1/24
ListenPort = 10000
PrivateKey = 
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o enp0s3 -j MASQUERADE
```
```sh
sudo systemctl start wg-quick@wg0
sudo systemctl enable wg-quick@wg0
sudo systemctl status wg-quick@wg0

sudo wg show wg0
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
Debian install cloudflare warp
```sh
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
```
```sh
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
```
```sh
sudo apt-get update && sudo apt-get install cloudflare-warp
```

Ubuntu install cloudflare warp
```sh
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
```
```sh
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
```
```sh
sudo apt-get update && sudo apt-get install cloudflare-warp
```
```sh
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
warp-cli tunnel endpoint set 127.0.0.1:1080
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