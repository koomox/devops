# Docker for Ubuntu Server 17.04                     
### Docker             
Docker CE for github.com: [传送门](https://github.com/docker/docker-ce)                           
Docker CE for Ubuntu Install: [传送门](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)                           
Docker for DaoCloud 高速镜像安装包: [传送门](http://get.daocloud.io/)                   
Docker CE Stable 二进制包: [传送门](https://download.docker.com/linux/static/stable/x86_64/)             
Docker Compose for github.com: [传送门](https://github.com/docker/compose)                      

新建 docker 用户、组                      
```sh
groupadd docker
useradd  -r -g docker -s /bin/false docker
```                   

二进制包安装 Docker                    
原版: `/lib/systemd/system/docker.service` [点击查看源文件](../../storage/linux/scripts/docker/ubuntuserver1704/docker.service)                        
阿里云加速器版: `/lib/systemd/system/docker.service` [点击查看源文件](../../storage/linux/scripts/docker/ubuntuserver1704/docker-fast.service)                        
`/lib/systemd/system/docker.socket` [点击查看源文件](../../storage/linux/scripts/docker/ubuntuserver1704/docker.socket)                       
```sh
mkdir /docker
cd /docker

wget https://download.docker.com/linux/static/stable/x86_64/docker-18.06.3-ce.tgz

tar -zxf docker-18.06.3-ce.tgz
sudo \cp -f docker/* /usr/local/bin/

\rm -rf /lib/systemd/system/docker.service /lib/systemd/system/docker.socket
wget -O /lib/systemd/system/docker.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/docker/ubuntuserver1704/docker-fast.service
wget -O /lib/systemd/system/docker.socket https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/docker/ubuntuserver1704/docker.socket

groupadd docker
useradd  -r -g docker -s /bin/false docker

systemctl enable docker
systemctl start docker
```
二进制包安装 Docker-compose                
```sh
curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

docker-compose --version
```