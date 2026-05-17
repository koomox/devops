# openwrt                               
openwrt 15.05 x86 IMG镜像: [点击下载](https://downloads.openwrt.org/chaos_calmer/15.05/x86/generic/openwrt-15.05-x86-generic-combined-squashfs.img)                  
openwrt 18.06.2 x86 IMG镜像: [点击下载](https://downloads.openwrt.org/releases/18.06.2/targets/x86/generic/openwrt-18.06.2-x86-generic-combined-squashfs.img.gz)       
openwrt 19.07.1 x86 IMG镜像: [点击下载](https://downloads.openwrt.org/releases/19.07.1/targets/x86/generic/openwrt-19.07.1-x86-generic-combined-squashfs.img.gz)            
openwrt 21.02.1 x86 IMG镜像: [点击下载](https://downloads.openwrt.org/releases/21.02.1/targets/x86/generic/openwrt-21.02.1-x86-generic-generic-squashfs-combined.img.gz)
openwrt 下载地址: [Link](https://downloads.openwrt.org/)                                    
参考文档: [传送门](http://blog.csdn.net/xingyuzhe/article/details/51280337)                          
### Linux Kernel        
openwrt 18.06 Linux Kernel 升级到 4.14           

### 转换镜像文件         
安装 qemu-utils ，使用 qemu-img 工具转换镜像文件。                      
```sh
sudo apt install qemu-utils
```
将img镜像文件转换为vmdk文件                           
```sh
qemu-img convert -f raw openwrt-21.02.1-x86-generic-squashfs.img -O vmdk openwrt-21.02.1-x86-generic.vmdk

#wget https://downloads.openwrt.org/releases/21.02.1/targets/x86/generic/openwrt-21.02.1-x86-generic-generic-ext4-combined.img.gz
wget https://downloads.openwrt.org/releases/21.02.1/targets/x86/generic/openwrt-21.02.1-x86-generic-generic-squashfs-combined.img.gz
gzip -d openwrt-21.02.1-x86-generic-generic-squashfs-combined.img.gz
qemu-img convert -f raw openwrt-21.02.1-x86-generic-generic-squashfs-combined.img -O vmdk openwrt-21.02.1-x86-generic-squashfs.vmdk
```
设置IP地址，修改`/etc/config/network`配置文件。     

### Raspberry 3b+        
```sh
# wget https://downloads.openwrt.org/releases/21.02.1/targets/bcm27xx/bcm2710/openwrt-21.02.1-bcm27xx-bcm2710-rpi-3-squashfs-factory.img.gz
wget https://downloads.openwrt.org/releases/21.02.1/targets/bcm27xx/bcm2710/openwrt-21.02.1-bcm27xx-bcm2710-rpi-3-ext4-factory.img.gz
gzip -d openwrt-21.02.1-bcm27xx-bcm2710-rpi-3-ext4-factory.img.gz
qemu-img convert -f raw openwrt-21.02.1-bcm27xx-bcm2710-rpi-3-ext4-factory.img -O vmdk openwrt-21.02.1-bcm27xx-bcm2710-rpi-3-ext4-factory.vmdk
```    