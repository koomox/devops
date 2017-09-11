# openwrt                               
openwrt 15.05 x86 IMG镜像: [点击下载](https://downloads.openwrt.org/chaos_calmer/15.05/x86/generic/openwrt-15.05-x86-generic-combined-squashfs.img)                               
参考文档: [传送门](http://blog.csdn.net/xingyuzhe/article/details/51280337)                          

安装 qemu-img                       
```sh
sudo apt-get install qemu-img
```

将img镜像文件转换为vmdk文件                           
```sh
qemu-img convert -f raw openwrt-15.05-x86-generic-combined-squashfs.img -O vmdk openwrt-15.05-x86-generic-combined.vmdk
```
