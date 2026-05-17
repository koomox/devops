# Proxmox VE          
### Debian 安装 proxmox            
```sh
sudo hostnamectl set-hostname pve --static
192.168.0.253   pve.proxmox.com pve
```
```sh
echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list

echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" | sudo tee /etc/apt/sources.list.d/pve-install-repo.list
```
```sh
wget http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg -O /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
chmod +r /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
```
```sh
apt update && apt full-upgrade
```
```sh
apt install proxmox-ve postfix open-iscsi
```

### 打开CPU虚拟化功能          
如果操作硬件直通，提示  `No IOMMU detected, please activate it.See Documentation for further information.` 执行如下操作             
```sh
vi /etc/default/grub
```
找到        
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
```
修改为       
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"
```
更新         
```sh
update-grub
```
重启系统
### 移除 PVE 没有有效订阅的提示             
```sh
vi /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
```
找到          
```js
if (data.status !== 'Active')
```
修改为          
```js
if (false)
```
重启网页服务      
```sh
systemctl restart pveproxy
```
### PVE 导入 ROS OVF 文件              
打开 VMware 把 `ROS6.ova` 转换为 `ROS6.ovf` `ROS6.mf` `ROS6.vmdk`            
将获取到得三个文件上传到 PVE 磁盘中, 打开 Shell 输入, `100` 为 100             
```sh
qm importovf 100 ROS6.ovf local --format qcow2
```
编辑配置文件                     
```sh
vi /etc/pve/nodes/pve/qemu-server/110.conf
```
找到 `ide0` 这一行在末尾添加如下内容并保存            
```
,model=VMware%20Virtual%20IDE%20Hard%20Drive,serial=00000000000000000001
```
现在就可以启动 ROS 虚拟机了。            