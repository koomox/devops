# 封装 Windows 7 镜像常用的软件        
### Internet Explorer                  
Internet Explorer 11 脱机安装程序: [传送门](https://support.microsoft.com/zh-cn/help/18520/download-internet-explorer-11-offline-installer)        

把 IE11 集成到 Win 7 镜像            
```bat
@echo off
SET N_PATH=%~dp0
md "%N_PATH%\IE11"
"%N_PATH%\IE11-Windows6.1-x64-zh-cn.exe" /x:"%N_PATH%\IE11"
dism /image:d:\win7\wim /Add-Package /PackagePath:"%N_PATH%\IE11\IE-Win7.CAB"
dism /image:d:\win7\wim /Add-Package /PackagePath:"%N_PATH%\IE11\ielangpack-zh-CN.CAB"
dism /image:d:\win7\wim /Add-Package /PackagePath:"%N_PATH%\IE11\IE-Hyphenation-en.MSU"
dism /image:d:\win7\wim /Add-Package /PackagePath:"%N_PATH%\IE11\IE-Spelling-en.MSU"
pause
```
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
Adobe Acrobat Reader DC 离线下载: [传送门](http://get.adobe.com/reader/enterprise/)        
### 压缩软件              
WinRAR 5.31 中文版 x64: [点击下载](http://www.rarlab.com/rar/winrar-x64-531sc.exe)              
WinRAR 5.31 中文版 x86: [点击下载](http://www.rarlab.com/rar/wrar531sc.exe)             
WinRAR 5.40 英文版 x64: [点击下载](http://www.rarlab.com/rar/winrar-x64-540.exe)          
WinRAR 5.40 英文版 x86: [点击下载](http://www.rarlab.com/rar/wrar540.exe)           

7-Zip 16.04 x64: [点击下载](http://www.7-zip.org/a/7z1604-x64.exe)           
7-Zip 16.04 x86: [点击下载](http://www.7-zip.org/a/7z1604.exe)           
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
Firefox Developer Edition 下载地址: [传送门](https://www.mozilla.org/en-US/firefox/developer/all/)          
### UltraISO          
UltraISO 9.7.0.3476: [下载地址](https://cn.ultraiso.net/uiso9_cn.exe)                

### Git            
Git Windows 客户端: [传送门](https://git-scm.com/downloads) [下载地址](https://git-scm.com/download/win)                             
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