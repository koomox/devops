# OpenWRT              
下载镜像，下载其中一个即可。                   
```sh
wget https://downloads.openwrt.org/releases/18.06.2/targets/x86/generic/openwrt-18.06.2-x86-generic-combined-squashfs.img.gz
wget https://downloads.openwrt.org/releases/18.06.2/targets/x86/generic/openwrt-18.06.2-x86-generic-combined-ext4.img.gz
```
Vmware 需要将img转换为vmdk格式，使用`qemu-img`工具。       
```sh
apt install qemu-utils
```
解压镜像并转换格式         
```sh
gzip -d openwrt-18.06.2-x86-generic-combined-ext4.img.gz
qemu-img convert -f raw openwrt-18.06.2-x86-generic-combined-ext4.img -O vmdk openwrt-18.06.2-x86-generic-combined-ext4.vmdk
```
设置IP地址，修改`/etc/config/network`配置文件。         