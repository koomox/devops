# 封装 Windows 7 镜像常用的软件        
按 `Ctrl+Shift+F3` 跳过 Windows 7 用户名，重启进入系统。            
### Internet Explorer                  
Internet Explorer 11 脱机安装程序: [传送门](https://support.microsoft.com/zh-cn/help/18520/download-internet-explorer-11-offline-installer)        
### 浏览器           
Firefox 浏览器 Yandex网盘下载地址: [传送门](https://yadi.sk/d/ibRwSIUB3RVgaY)        
Chrome 浏览器 Yandex网盘下载地址: [传送门](https://yadi.sk/d/UA19ezYD3RVpWc)          
Vivaldi 浏览器 Yandex网盘下载地址: [传送门](https://yadi.sk/d/k997yhl03RVusg)          
SwitchyOmega 插件 Yandex网盘下载地址: [传送门](https://yadi.sk/d/SZ8brSNK3RVpjS)            
Adobe Flash Player 插件 Yandex网盘下载地址: [传送门](https://yadi.sk/d/S3aGTgqU3RVUyC)         
### Microsoft .NET Framework        
.NET Framework 3.5 Service pack 1 (Full Package)：[传送门](https://www.microsoft.com/zh-CN/download/details.aspx?id=25150)        
.NET Framework 3.5 SP1 语言包: [传送门](https://www.microsoft.com/zh-cn/download/details.aspx?id=21891)        
.NET Framework 4 离线安装包: [传送门](https://www.microsoft.com/zh-cn/download/details.aspx?id=17718)            
.NET Framework 4.6.2 离线安装包: [传送门](https://www.microsoft.com/zh-CN/download/details.aspx?id=53344)        
.NET Framework 4.6.2 语言包: [传送门](https://www.microsoft.com/zh-cn/download/details.aspx?id=53323)        
.Net 4.7 离线安装包: [传送门](https://www.microsoft.com/zh-CN/download/details.aspx?id=55167)        
.Net 4.7 中文语言包: [传送门](https://www.microsoft.com/zh-cn/download/details.aspx?id=55169)          
.Net 4.6.2 离线安装包: [点击下载](https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe)        
.Net 4.6.2 中文语言包: [点击下载](https://download.microsoft.com/download/8/B/2/8B2599C3-2156-4B01-AE62-636B2CD4B9D2/NDP462-KB3151800-x86-x64-AllOS-CHS.exe)        
.Net 4.7 离线安装包: [点击下载](https://download.microsoft.com/download/D/D/3/DD35CC25-6E9C-484B-A746-C5BE0C923290/NDP47-KB3186497-x86-x64-AllOS-ENU.exe)        
.Net 4.7 中文语言包: [点击下载](https://download.microsoft.com/download/4/4/7/447FC039-EAA9-41EB-B96F-86D6146D7A92/NDP47-KB3186497-x86-x64-AllOS-CHS.exe)        
.Net 4.7.2 离线安装包: [点击下载](http://download.microsoft.com/download/3/D/7/3D72C5C2-4CCB-4EEF-925D-B5FA33EAC25A/NDP472-KB4054530-x86-x64-AllOS-ENU.exe)        
.Net 4.7.2 中文语言包: [点击下载](http://download.microsoft.com/download/D/E/D/DEDCBE28-6398-47FE-8E96-3D55F524F211/NDP472-KB4054530-x86-x64-AllOS-CHS.exe)        

Win7 安装 .Net 4.7 需要先打上KB4019990补丁: [传送门](https://support.microsoft.com/zh-cn/help/4020302/the-net-framework-4-7-installation-is-blocked-on-windows-7-windows-ser)        
KB4019990 x64: [点击下载](http://download.microsoft.com/download/2/F/4/2F4F48F4-D980-43AA-906A-8FFF40BCB832/Windows6.1-KB4019990-x64.msu)        
KB4019990 x86: [点击下载](http://download.microsoft.com/download/2/F/4/2F4F48F4-D980-43AA-906A-8FFF40BCB832/Windows6.1-KB4019990-x86.msu)        


用管理员身份打开命令提示符，执行如下命令安装KB4019990补丁                  
```bat
@echo off
cd /d %~dp0
md update
expand -F:* Windows6.1-KB4019990-x64.msu update
dism /online /Add-Package /PackagePath:update\Windows6.1-KB4019990-x64.cab
rd /s /q update
pause
```
### Adobe
Adobe Flash Player 离线下载: [传送门](http://www.adobe.com/support/flashplayer/debug_downloads.html)          
Adobe Flash Player Yandex网盘下载地址: [传送门](https://yadi.sk/d/S3aGTgqU3RVUyC)         
Adobe Acrobat Reader DC 离线下载: [传送门](http://get.adobe.com/reader/enterprise/)        
### Google Chrome 49.0.2623.112 XP 系统最终版官方下载地址               
32位下载地址: [点击下载](http://dl.google.com/release2/h8vnfiy7pvn3lxy9ehfsaxlrnnukgff8jnodrp0y21vrlem4x71lor5zzkliyh8fv3sryayu5uk5zi20ep7dwfnwr143dzxqijv/49.0.2623.112_chrome_installer.exe)            
64位下载地址: [点击下载](http://dl.google.com/release2/va5qxmf7d3oalefqdjoubnamxboyf9zt3o6zj33pzo2r3adq2cjea9an8hhc6tje8y4jiieqsruld9oyajv9i6atj40utl3hpl2/49.0.2623.112_chrome_installer_win64.exe)                       
### Firefox 52.0.2 XP 系统最终版官方下载地址               
32位下载地址: [点击下载](https://ftp.mozilla.org/pub/firefox/releases/52.0.2/win32/zh-CN/Firefox%20Setup%2052.0.2.exe)        
64位下载地址: [点击下载](https://ftp.mozilla.org/pub/firefox/releases/52.0.2/win64/zh-CN/Firefox%20Setup%2052.0.2.exe)       
### 压缩软件              
WinRAR 5.31 中文版 x64: [点击下载](http://www.rarlab.com/rar/winrar-x64-531sc.exe)              
WinRAR 5.31 中文版 x86: [点击下载](http://www.rarlab.com/rar/wrar531sc.exe)               
WinRAR 5.31 Key: [点击查看源文件](../storage/windows/winrar/531/rarreg.key)             
WinRAR 5.50 中文版 x64: [点击下载](https://www.win-rar.com/fileadmin/winrar-versions/sc20170830/wrr/winrar-x64-550sc.exe
)              
WinRAR 5.50 中文版 x86: [点击下载](https://www.win-rar.com/fileadmin/winrar-versions/sc20170830/wrr/wrar550sc.exe)         
WinRAR 5.50 英文版 x64: [点击下载](https://www.rarlab.com/rar/winrar-x64-550.exe)          
WinRAR 5.50 英文版 x86: [点击下载](https://www.rarlab.com/rar/wrar550.exe)           
WinRAR 5.60 中文版 x64: [点击下载](https://www.win-rar.com/fileadmin/winrar-versions/sc20180711/wrr/winrar-x64-560sc.exe
)              
WinRAR 5.60 中文版 x86: [点击下载](https://www.win-rar.com/fileadmin/winrar-versions/sc20180711/wrr/wrar560sc.exe)        
WinRAR 5.60 英文版 x64: [点击下载](https://www.rarlab.com/rar/winrar-x64-560.exe)          
WinRAR 5.60 英文版 x86: [点击下载](https://www.rarlab.com/rar/wrar560.exe)           
WinRAR 5.60 Key: [点击查看源文件](../storage/windows/winrar/560/rarreg.key)             

WinRAR 5.70 英文版 x64: [点击下载](https://www.rarlab.com/rar/winrar-x64-570.exe)          
WinRAR 5.70 英文版 x86: [点击下载](https://www.rarlab.com/rar/wrar570.exe)          

WinRAR 7-Zip Yandex网盘下载地址: [传送门](https://yadi.sk/d/jU4cCAdX3RVryV)               

7-Zip 16.04 x64: [点击下载](http://www.7-zip.org/a/7z1604-x64.exe)           
7-Zip 16.04 x86: [点击下载](http://www.7-zip.org/a/7z1604.exe)           
7-Zip 18.05 x64: [点击下载](https://www.7-zip.org/a/7z1805-x64.exe)           
7-Zip 18.05 x86: [点击下载](https://www.7-zip.org/a/7z1805.exe)           
7-Zip 19.00 x64: [点击下载](https://www.7-zip.org/a/7z1900-x64.exe)           
7-Zip 19.00 x86: [点击下载](https://www.7-zip.org/a/7z1900.exe)           
### Skype
Skype 国际版离线安装包: [点击下载](http://www.skype.com/go/getskype-full?source=lightinstaller)          
### Intel USB 3.0              
Intel USB 3.0 驱动: [传送门](https://downloadcenter.intel.com/download/22824/Intel-USB-3-0-eXtensible-Host-Controller-Driver-for-Intel-8-9-100-Series-and-Intel-C220-C610-Chipset-Family?product=65855)        
```bat
@echo on
SET N_DRIVE=%~d0
SET N_PATH=%~dp0
SET N_DISM_DRIVE=F:
SET WIM_MOUNTPATH=D:\mount\win7
cd /d %N_DISM_DRIVE%\RecoveryImage\PE_Tools\10\Deployment_Tools\amd64\DISM
Dism /Mount-Wim /WimFile:%N_PATH%install.wim /Index:4 /MountDir:%WIM_MOUNTPATH%
Dism /Image:%WIM_MOUNTPATH% /Add-Driver /Driver:%N_PATH%\Drivers\USB3.0\HCSwitch\x64 /Recurse
Dism /Image:%WIM_MOUNTPATH% /Add-Driver /Driver:%N_PATH%\Drivers\USB3.0\Win7\x64 /Recurse
Dism /Commit-Wim /MountDir:%WIM_MOUNTPATH%
Dism /Unmount-Wim /MountDir:%WIM_MOUNTPATH% /Commit
pause
```     
### winsock            
重置 winsock 协议使用如下命令             
```bat
netsh winsock reset
```

重置 TCP/IP 协议                   
```bat
netsh int ip reset              
```
### sysprep             
```bat
%windir%\System32\sysprep\sysprep.exe
```              
### Security Essentials            
Security Essentials 下载: [传送门](https://support.microsoft.com/zh-cn/help/14210/security-essentials-download)           
### Firefox         
Firefox 下载地址: [传送门](https://www.mozilla.org/en-US/firefox/all/)             
Firefox Yandex网盘下载地址: [传送门](https://yadi.sk/d/ibRwSIUB3RVgaY)        
Firefox Developer Edition 下载地址: [传送门](https://www.mozilla.org/en-US/firefox/developer/all/)          
### UltraISO          
UltraISO 9.7.0.3476: [下载地址](https://cn.ultraiso.net/uiso9_cn.exe)                

### Git            
Git Windows 客户端: [传送门](https://git-scm.com/downloads) [下载地址](https://git-scm.com/download/win)                             
Git Windows 客户端 Yandex网盘下载: [传送门](https://yadi.sk/d/ipMAVvz73RVvHy)            
TortoiseGit 客户端: [传送门](https://tortoisegit.org/) [下载地址](https://tortoisegit.org/download/)          
Desktop for GitHub: [传送门](https://desktop.github.com/)            

### Xshell           
Xshell: [传送门](https://www.netsarang.com/download/down_form.html?code=522&downloadType=0&licenseType=1)                
### FileZilla         
FileZilla: [传送门](https://sourceforge.net/projects/filezilla/files/FileZilla_Client/)               
### MariaDB MySQL          
MariaDB: [传送门](https://downloads.mariadb.org/)           
MySQL: [传送门](https://dev.mysql.com/downloads/mysql/)            
### Windows loader              
Windows loader 激活命令               
```bat
"windows loader.exe" /silent /norestart
```  
### Notepad++ 7.5.4         
Notepad++ Yandex网盘下载: [传送门](https://yadi.sk/d/p7cVLZVR3RVsDQ)           
### FastStone         
FastStone Capture: [传送门](http://www.faststone.org/FSCapturerDownload.htm)           
FastStone Capture 8.6: [点击下载](http://www.faststonesoft.net/DN/FSCaptureSetup86.exe)           
FastStone Image Viewer: [传送门](http://www.faststone.org/FSViewerDownload.htm)         
FastStone Image Viewer 6.3: [点击下载](http://www.faststonesoft.net/DN/FSViewerSetup63.exe)             
FastStone 相关软件 Yandex网盘下载: [传送门](https://yadi.sk/d/NeaL6o493RVsPU)         
### 迅雷下载       
迅雷极速版: Yandex网盘下载: [传送门](https://yadi.sk/d/N90Up-Ze3RVsVA)         