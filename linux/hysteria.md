# hysteria2         
Home [Link](https://v2.hysteria.network/)            
### Install or Uninstall       
Install or upgrade to the latest version.          
```sh
bash <(curl -fsSL https://get.hy2.sh/)
```
Remove Hysteria and its service.      
```sh
bash <(curl -fsSL https://get.hy2.sh/) --remove
```

### Configuration File      
Edit Configuration File        
```sh
sudo vim /etc/hysteria/config.yaml
```
If there is no domain name, generate a self-signed certificate          
```sh
openssl ecparam -name prime256v1 -out ecparams.pem
sudo openssl req -x509 -nodes -newkey ec:ecparams.pem -keyout /etc/hysteria/server.key -out /etc/hysteria/server.crt -subj "/CN=bing.com" -days 36500
sudo chown hysteria /etc/hysteria/server.key
sudo chown hysteria /etc/hysteria/server.crt
```
Full Server Config           
```
listen: :443 

tls:
  cert: /etc/hysteria/server.crt 
  key: /etc/hysteria/server.key 

auth:
  type: password
  password: @password@ 

masquerade: 
  type: proxy
  proxy:
    url: https://bing.com 
    rewriteHost: true
```

```sh
sudo sed -i "s/@password@/\"$(openssl rand -hex 32)\"/" /etc/hysteria/config.yaml
``` 
Enable the service at startup and start it immediately.        
```sh
sudo systemctl enable --now hysteria-server.service
```
Restart the service, usually after modifying the configuration file.         
```sh
sudo systemctl restart hysteria-server.service
```
Check the service status.      
```sh
sudo systemctl status hysteria-server.service
```