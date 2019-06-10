# Nginx            
### 一键安装脚本        
Linux 一键安装脚本 [查看源文件](../storage/linux/scripts/nginx/install_nginx1142.sh)         
```sh
curl -s https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/install_nginx1142.sh -o /tmp/install_nginx1142.sh
chmod +x /tmp/install_nginx1142.sh
/tmp/install_nginx1142.sh
```
Linux 下载 nginx 相关文件打包后，上次至 Firefox Send。             
```sh
curl -s https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/download_nginx1142.sh -o /tmp/download_nginx1142.sh
chmod +x /tmp/download_nginx1142.sh
/tmp/download_nginx1142.sh
```
一键安装 Nginx 1.16.0 [查看源文件](../storage/linux/scripts/nginx/install_nginx1160.sh)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/install_nginx1160.sh
chmod +x ./install_nginx1160.sh
./install_nginx1160.sh
```

```sh
sed -i 's/localhost/*.com www.*.com/g' /etc/nginx/conf.d/*.com.conf
sed -i 's/$domain/*.com/g' /etc/nginx/conf.d/*.com.conf
```
```sh
mkdir -p /etc/letsencrypt/live/$domain
touch /etc/letsencrypt/live/$domain/fullchain.pem
touch /etc/letsencrypt/live/$domain/privkey.pem
```