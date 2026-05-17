# PXE             
### syslinux        
syslinux 下载地址: [传送门](https://mirrors.kernel.org/pub/linux/utils/boot/syslinux/)                 
```sh
curl -LO https://mirrors.kernel.org/pub/linux/utils/boot/syslinux/syslinux-5.10.tar.xz
xz -d syslinux-5.10.tar.xz
tar -xf syslinux-5.10.tar

```
```sh
yum install nasm libuuid-devel
```
```sh
mkdir -p /data/pxe/boot/bios
curl -LO https://mirrors.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz
xz -d syslinux-6.03.tar.xz
tar -xf syslinux-6.03.tar
cd syslinux-6.03
\cp -f ./bios/core/pxelinux.0 /data/pxe/boot/bios
\cp -f ./bios/com32/menu/vesamenu.c32 /data/pxe/boot/bios
\cp -f ./bios/com32/menu/menu.c32 /data/pxe/boot/bios
\cp -f ./bios/com32/chain/chain.c32 /data/pxe/boot/bios
\cp -f ./bios/memdisk/memdisk /data/pxe/boot/bios
\cp -f ./bios/com32/lib/libcom32.c32 /data/pxe/boot/bios
\cp -f ./bios/com32/elflink/ldlinux/ldlinux.c32 /data/pxe/boot/bios
\cp -f ./bios/com32/libutil/libutil.c32 /data/pxe/boot/bios
\cp -f ./bios/com32/modules/linux.c32 /data/pxe/boot/bios
\cp -f ./bios/com32/modules/pxechn.c32 /data/pxe/boot/bios
mkdir -p /data/pxe/boot/bios/pxelinux.cfg
touch /data/pxe/boot/bios/pxelinux.cfg/default

mkdir -p /data/pxe/boot/efi64
\cp -f ./efi64/efi/syslinux.efi /data/pxe/boot/efi64
\cp -f ./efi64/com32/menu/vesamenu.c32 /data/pxe/boot/efi64
\cp -f ./efi64/com32/elflink/ldlinux/ldlinux.e64 /data/pxe/boot/efi64
\cp -f ./efi64/com32/lib/libcom32.c32 /data/pxe/boot/efi64
\cp -f ./efi64/com32/libutil/libutil.c32 /data/pxe/boot/efi64
\cp -f ./efi64/com32/modules/linux.c32 /data/pxe/boot/efi64
\cp -f ./efi64/com32/modules/pxechn.c32 /data/pxe/boot/efi64
mkdir -p /data/pxe/boot/efi64/pxelinux.cfg
touch /data/pxe/boot/efi64/pxelinux.cfg/default
```

```ini
DEFAULT vesamenu.c32
MENU TITLE === PXE Boot Server ===
menu color title 1;36;44 #ffffffff #00000000 std

LABEL fog.local
localboot 0
MENU DEFAULT
MENU LABEL Boot from hard disk
TEXT HELP
Boot from the local hard drive.
If you are unsure, select this option.
ENDTEXT
```
### Dnsmasq          
Dnsmasq 可以同时提供DNS、DHCP、TFTP的功能。             
```ini
listen-address=192.168.87.88,127.0.0.1
dhcp-range=192.168.87.100,192.168.87.200,24h
dhcp-host=00:0C:29:2F:81:17,192.168.87.208
dhcp-option=3,192.168.87.2
enable-tftp
tftp-root=/data/pxe/boot/bios
dhcp-boot=pxelinux.0
```