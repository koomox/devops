# MIUI           
### install ADB and fastboot             
SDK platform tools [Link](https://developer.android.com/studio/releases/platform-tools)                
Download SDK Platform-Tools for Windows, 解压后添加到系统环境变量。 就可以使用 adb、fastboot 命令了。                   
### MIUI 启用开发者选项              
多次点击 `MIUI版本`, 启用 `开发者选项`           
![](/static/images/wiki/IMG_20200316_122000.jpg)             
打开 `USB 调试` 滑动开关按钮          
![](/static/images/wiki/IMG_20200316_122001.jpg)           
### Adb 调试         
小米手机开机后，通过数据线连接到PC。         
```sh
adb devices
```
重启到 bootloader 命令             
```sh
adb reboot bootloader
```
进入 9008 mode      
```sh
adb reboot edl
```
屏幕截图保存在 `/sdcard/screenshot.png`, 再把图片文件复制到电脑桌面。                       
```sh
adb shell /system/bin/screencap -p /sdcard/screenshot.png

adb pull /sdcard/screenshot.png %USERPROFILE%\Desktop\
```
录制视频，默认 180s, 指定录制10s, 分辨率为 1280x720的mp4视频            
```sh
adb shell screenrecord --time-limit 60 --size 1280x720 /sdcard/demo.mp4
```
关闭 ADB 服务, 第一条命令无效的时候，使用第二条命令强杀。               
```sh
adb kill-server
taskkill /f /im adb.exe
```
#### 使用 WIFI 无线连接          
启用 WIFI 无线连接 ADB, 手机需要数据线连接到电脑，执行命令后拔掉数据线。 这个端口可以自定义                  
```sh
adb tcpip 5555
```
通过 WIFI 进行连接，执行命令          
```sh
adb connect ip:5555

adb disconnect ip:5555

adb -s ip:port shell 
```
切换回 USB 模式           
```sh
adb usb
```
### Fastboot           
```sh
fastboot devices
```
重启手机         
```sh
fastboot reboot
```
进入 9008 模式          
```sh
fastboot oem edl

fastboot reboot emergency
```
刷机命令         
```sh
fastboot erase boot
fastboot flash modem %~dp0\images\NON-HLOS.bin
fastboot flash sbl1 %~dp0\images\sbl1.mbn
fastboot flash sbl1bak %~dp0\images\sbl1.mbn
fastboot flash rpm %~dp0\images\rpm.mbn
fastboot flash rpmbak %~dp0\images\rpm.mbn
fastboot flash tz %~dp0\images\tz.mbn
fastboot flash tzbak %~dp0\images\tz.mbn
fastboot flash devcfg %~dp0\images\devcfg.mbn
fastboot flash devcfgbak %~dp0\images\devcfg.mbn
fastboot flash dsp %~dp0\images\adspso.bin
fastboot flash sec %~dp0\images\sec.dat
fastboot flash splash %~dp0\images\splash.img
fastboot flash aboot %~dp0\images\emmc_appsboot.mbn
fastboot flash abootbak %~dp0\images\emmc_appsboot.mbn
fastboot flash boot %~dp0\images\boot.img
fastboot flash recovery %~dp0\images\recovery.img
fastboot flash system %~dp0\images\system.img
fastboot flash vendor %~dp0\images\vendor.img
fastboot flash cache %~dp0\images\cache.img
fastboot flash lksecapp %~dp0\images\lksecapp.mbn
fastboot flash lksecappbak %~dp0\images\lksecapp.mbn
fastboot flash cmnlib %~dp0\images\cmnlib_30.mbn
fastboot flash cmnlibbak %~dp0\images\cmnlib_30.mbn
fastboot flash cmnlib64 %~dp0\images\cmnlib64_30.mbn
fastboot flash cmnlib64bak %~dp0\images\cmnlib64_30.mbn
fastboot flash keymaster %~dp0\images\keymaster64.mbn
fastboot flash keymasterbak %~dp0\images\keymaster64.mbn
fastboot flash cust %~dp0\images\cust.img
fastboot flash userdata %~dp0\images\userdata.img
```