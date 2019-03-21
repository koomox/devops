# CoreOS           
CoreOS ISO镜像: [传送门](https://coreos.com/os/docs/latest/booting-with-iso.html)             
CoreOS 虚拟机镜像: [传送门](https://coreos.com/os/docs/latest/booting-on-vmware.html)            
CoreOS 下载地址: [传松门](http://stable.release.core-os.net/amd64-usr/current/)              
硬盘安装文档: [传送门](https://coreos.com/os/docs/latest/installing-to-disk.html)              
配置文件: [传送门](https://coreos.com/os/docs/latest/cloud-config.html)               

### 下载 ISO 镜像               
```sh
wget https://stable.release.core-os.net/amd64-usr/current/coreos_production_iso_image.iso
```
启动镜像，做本地镜像服务器使用，sig为验证文件。             
```sh
wget https://stable.release.core-os.net/amd64-usr/current/coreos_production_image.bin.bz2
wget https://stable.release.core-os.net/amd64-usr/current/coreos_production_image.bin.bz2.sig
```
创建密码              
```sh
sudo openssl passwd -1
```
创建配置文件
```sh
vi cloud-config
```
内容，配置文件必须以`#cloud-config`开始                
```ini
#cloud-config

hostname: "coreos1"

users:
  - name: "core"
    passwd: "$6$5s2u6/jR$un0AvWnqilcgaNB3Mkxd5yYv6mTlWfOoCYHZmfi3LDKVltj.E8XNKEcwWm..."
    groups:
      - "sudo"
      - "docker"
    ssh-authorized-keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0g+ZTxC7weoIJLUafOgrm+h..."
```
安装命令                
`-d` 指定安装到哪块硬盘，/dev/sda、/dev/sdb、/dev/sdc ...              
`-c` 指定初始化yaml文件              
`-b` 指定安装bin文件镜像服务器，不指定默认从官网下载             
```sh
sudo coreos-install -d /dev/sda -C stable -c ./cloud-config-file
```
```sh
sudo coreos-install -d /dev/sda -C stable -c ./cloud-config-file -b http://192.168.0.8:8080/coreos
```
如果忘记密码，CoreOS启动GRUB按E编译，加上参数`coreos.autologin`即可自动登录系统，使用`sudo passwd root`修改密码。              

```sh
sudo parted /dev/sda
		mkpart
		Partition name? DATA
		File system type? 
		Start? Now
		End? -1
		p

sudo mkfs.ext4 /dev/sda5
df -h
sudo mount /dev/sda5 /data
```
### 调整 Docker 默认存储地址              
参考文档: [传送门](https://docs.docker.com/config/daemon/systemd/)            
```sh
sudo mkdir -p /etc/docker/
sudo touch /etc/docker/daemon.json
sudo vim /etc/docker/daemon.json
```
内容
```json
{
    "data-root": "/mnt/docker-data",
    "storage-driver": "overlay"
}
```