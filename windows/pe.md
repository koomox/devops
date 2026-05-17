# PE                  
WinPE：创建 USB 可启动驱动器: [传送门](https://technet.microsoft.com/zh-cn/library/hh825109.aspx)             
WinPE 网络驱动程序：初始化和添加驱动程序: [传送门](https://technet.microsoft.com/zh-cn/library/hh824935.aspx)             
WinPE：装载和自定义: [传送门](https://technet.microsoft.com/zh-cn/library/hh824972.aspx)               
适用于 Windows 8 的 WinPE：Windows PE 5.0[传送门](https://technet.microsoft.com/zh-cn/library/hh825110.aspx)               

部署和映像工具环境: `"%ProgramData%\Microsoft\Windows\Start Menu\Programs\Windows Kits\Windows ADK"`                  
目录: `"%ProgramFiles(x86)%\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"`                          

由 Copype 创建目录结构并复制 Windows PE 文件到 `C:\winpe_amd64`
```bat
copype amd64 C:\winpe_amd64
```

将 Windows PE 安装到 U 盘，并指定驱动器号        
```bat
MakeWinPEMedia /UFD C:\winpe_amd64 F:
```       
清除 U 盘，然后重新安装 Windows PE。这可以帮助你删除额外的启动分区或其他启动软件。           
```bat
diskpart
  list disk
  select disk <disk number>
  clean
  create partition primary
  format quick fs=fat32 label="Windows PE"
  assign letter="F"
  exit

MakeWinPEMedia /UFD C:\winpe_amd64 F:
```                
从 DVD 启动 Windows PE。创建一个可以刻录到 DVD 的 ISO 文件            
```bat
MakeWinPEMedia /ISO C:\winpe_amd64 c:\winpe_amd64\winpe.iso
```
## 在 Windows PE 驱动器上存储 Windows 映像           
通常，不能在 Windows PE U 盘上存储或捕获 Windows 映像。         
大部分 U 盘仅支持单个驱动器分区。MakeWinPEMedia 命令将驱动器格式化为 FAT32，它支持启动基于 BIOS 和基于 UEFI 的 PC。该文件格式支持的最大文件大小仅为 4 GB。        
```bat
diskpart
  list disk
  select <disk number>
  clean
  rem === Create the Windows PE partition. ===
  create partition primary size=2000
  format quick fs=fat32 label="Windows PE"
  assign letter=P
  active
  rem === Create a data partition. ===
  create partition primary
  format fs=ntfs quick label="Other files"
  assign letter=O
  list vol
  exit

MakeWinPEMedia /UFD C:\WinPE_amd64 P:
```             
### 添加 Windows RE 启动项          
##### 创建隐藏分区         
`diskmgmt.msc` 打开磁盘管理，鼠标右键点击最后一个分区，选择`压缩卷`，大小输入`1024`，也就是1G容量。给新分区设置卷标`T`盘符      
`diskpart` 管理员模式打开分区工具，把刚才创建的`T`分区设置为隐藏分区。        
```
list disk
select disk 0
select partition 1
format quick fs=ntfs label="Windows RE tools"
assign letter=T
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
exit
```
##### 复制文件到隐藏分区            
可用的wim文件有两个，`*.iso\sources\boot.wim`或`*.iso\sources\install.wim\Windows\System32\Recovery\winre.wim`文件，以及`*.iso\boot\boot.sdi`文件。复制到`T:\Recovery\WindowsRE\`文件夹。          
首先查看WIM镜像文件详细信息          
```
Dism /Get-ImageInfo /ImageFile:.\install.wim
```
挂载WIM镜像文件            
```
Dism /Mount-Wim /WimFile:%WIM_FILE% /Index:%WIM_INDEX% /MountDir:%WIM_MOUNTPATH%
```
复制文件到隐藏分区           
```
rmdir /S /Q R:\Recovery
mkdir R:\Recovery
mkdir R:\Recovery\WindowsRE\
xcopy .\mount\Windows\System32\boot.sdi R:\Recovery\WindowsRE\ /H /K /Y
xcopy .\mount\Windows\System32\Recovery\winre.wim R:\Recovery\WindowsRE\ /H /K /Y

cd /d R:\Recovery\WindowsRE\
dir /a
```
卸载WIM镜像文件          
```
Dism /Unmount-Wim /MountDir:.\mount /Discard
```
##### 把 Windows RE 系统添加到系统启动项              
用管理员身份运行命令提示符，输入下面的命令获取启动项          
```
bcdedit /enum > "%USERPROFILE%\Desktop\os_bootlist.txt"
```
创建一个内存虚拟硬盘，系统自动生成一个GUID          
```
bcdedit /create /d "RE Ramdisk Options" /device >> "%USERPROFILE%\Desktop\os_bootlist.txt"
```
通过GUID设置SDI文件的分区号和路径。           
```
SET SDI_PART=T:
SET SDI_FILE=\Recovery\WindowsRE\boot.sdi
SET SDI_GUID={72dfcc76-9840-11e5-824e-94de80aa20ba}

bcdedit /set %SDI_GUID% ramdisksdidevice partition=%SDI_PART%
bcdedit /set %SDI_GUID% ramdisksdipath %SDI_FILE%
```
创建一个启动项，系统自动生成一个GUID            
```
bcdedit /create /d "Windows 10 RE" /application osloader >> "%USERPROFILE%\Desktop\os_bootlist.txt"
```
通过GUID设置启动项的相关参数。          
```
SET SDI_GUID={72dfcc76-9840-11e5-824e-94de80aa20ba}
SET WIM_GUID={72dfcc77-9840-11e5-824e-94de80aa20ba}
SET WIM_FILE=[T:]\Recovery\WindowsRE\winre.wim

bcdedit /set %WIM_GUID% device ramdisk=%WIM_FILE%,%SDI_GUID%
bcdedit /set %WIM_GUID% path \Windows\System32\winload.efi
bcdedit /set %WIM_GUID% osdevice ramdisk=%WIM_FILE%,%SDI_GUID%
bcdedit /set %WIM_GUID% systemroot \Windows
bcdedit /set %WIM_GUID% detecthal yes
bcdedit /set %WIM_GUID% winpe yes
bcdedit /displayorder %WIM_GUID% /addlast
```
##### 隐藏 Windows RE 分区        
```
list disk
select disk 0
select partition 1
remove
exit
```
##### 删除启动项            
```
SET SDI_GUID={36d941ca-937f-47f3-829c-7b45addb8a0c}
SET WIM_GUID={807e1a98-9ec4-41fd-a2d2-d128d6723a00}

bcdedit /delete %WIM_GUID% /cleanup
bcdedit /delete %SDI_GUID% /cleanup
```
##### 设置选择操作系统系列的等待时间            
设置为 5 秒          
```
bcdedit /timeout 5
```
### 添加 Windows PE 启动项         
Windows PE 下载: [传送门](https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/download-winpe--windows-pe)             
Windows 10 Version 1709 ADK 评估和部署工具包: [传送门](https://developer.microsoft.com/zh-cn/windows/hardware/windows-assessment-deployment-kit#winADK) [点击下载](https://go.microsoft.com/fwlink/p/?linkid=859206)      
加载ISO光盘映像文件，查看 `sources\boot.wim` 映像文件详细信息           
```
SET WIM_FILE=V:\sources\boot.wim

Dism /Get-ImageInfo /ImageFile:%WIM_FILE%
```
从 boot.wim 映像中导出索引1的映像文件。
```
SET WIM_FILE=V:\sources\boot.wim

Dism /Export-Image /SourceImageFile:%WIM_FILE% /SourceIndex:1 /DestinationImageFile:10PEX64.wim /DestinationName:"Windows 10 PE"
```
挂载WIM镜像文件          
```
SET WIM_FILE=F:\RecoveryImage\10\x64\20171109\PEX64.wim
SET WIM_INDEX=1
SET WIM_MOUNTPATH=D:\mount\win10pe

Dism /Mount-Wim /WimFile:%WIM_FILE% /Index:%WIM_INDEX% /MountDir:%WIM_MOUNTPATH%
```
将 PE 添加到启动项           
```
SET PE_SDI_GUID={}
SET PE_WIM_GUID={}
SET PE_SDI_PART=T:
SET PE_SDI_FILE=\boot\boot.sdi
SET PE_WIM_FILE=[T:]\boot\10pex64.wim
SET PE_WIM_BOOT_NAME="Windows 10 PE"

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /create /d %PE_WIM_BOOT_NAME% /device') DO @SET PE_SDI_GUID={%%I}
bcdedit /set %PE_SDI_GUID% ramdisksdidevice partition=%PE_SDI_PART%
bcdedit /set %PE_SDI_GUID% ramdisksdipath %PE_SDI_FILE%

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /create /d %PE_WIM_BOOT_NAME% /application osloader') DO @SET PE_WIM_GUID={%%I}
bcdedit /set %PE_WIM_GUID% device ramdisk=%PE_WIM_FILE%,%PE_SDI_GUID%
bcdedit /set %PE_WIM_GUID% path \Windows\System32\boot\winload.efi
bcdedit /set %PE_WIM_GUID% osdevice ramdisk=%PE_WIM_FILE%,%PE_SDI_GUID%
bcdedit /set %PE_WIM_GUID% systemroot \Windows
bcdedit /set %PE_WIM_GUID% detecthal yes
bcdedit /set %PE_WIM_GUID% winpe yes
bcdedit /displayorder %PE_WIM_GUID% /addlast
bcdedit /enum %PE_WIM_GUID%
```
### 将优启通添加到系统启动项            
优启通（EasyU）整合到恢复分区，并添加到系统启动项。Windows 启动管理器只能启动相同系统类型的操作系统（如都是x64），宿主机操作系统为 Windows 7 旗舰版 SP1，我想把 Windows 10 的 Windows RE和优启通整合到恢复分区。        
> 创建恢复分区的映像文件。      
>>1、在虚拟机中安装 Windows 10 x64 操作系统，创建恢复分区。           
>>2、安装优启通本地模式到恢复分区。         
>>3、将恢复分区备份为wim文件。           

将整合好的映像文件恢复到宿主机的恢复分区。           
```
Dism /Apply-Image /ImageFile:.\win10prex64.wim /Index:1 /ApplyDir:T:\
```
如果系统启动项比较混乱，可以重新创建系统启动文件。            
```
bcdboot C:\Windows /s S: /f UEFI /l zh-cn
```
添加 Windows 10 Recovery Environment 和 优启通 Windows 10 PE 到系统启动项。             
```
SET RE_SDI_GUID={}
SET RE_WIM_GUID={}
SET RE_SDI_PART=T:
SET RE_SDI_FILE=\Recovery\WindowsRE\boot.sdi
SET RE_WIM_FILE=[T:]\Recovery\WindowsRE\Winre.wim
SET RE_WIM_BOOT_NAME="Windows 10 Recovery Environment"

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /create /d %RE_WIM_BOOT_NAME% /device') DO @SET RE_SDI_GUID={%%I}
bcdedit /set %RE_SDI_GUID% ramdisksdidevice partition=%RE_SDI_PART%
bcdedit /set %RE_SDI_GUID% ramdisksdipath %RE_SDI_FILE%

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /create /d %RE_WIM_BOOT_NAME% /application osloader') DO @SET RE_WIM_GUID={%%I}
bcdedit /set %RE_WIM_GUID% device ramdisk=%RE_WIM_FILE%,%RE_SDI_GUID%
bcdedit /set %RE_WIM_GUID% path \Windows\System32\winload.efi
bcdedit /set %RE_WIM_GUID% locale zh-CN
bcdedit /set %RE_WIM_GUID% osdevice ramdisk=%RE_WIM_FILE%,%RE_SDI_GUID%
bcdedit /set %RE_WIM_GUID% systemroot \Windows
bcdedit /set %RE_WIM_GUID% detecthal yes
bcdedit /set %RE_WIM_GUID% winpe yes
bcdedit /displayorder %RE_WIM_GUID% /addlast
bcdedit /enum %RE_WIM_GUID%

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
SET PE_SDI_GUID={}
SET PE_WIM_GUID={}
SET PE_SDI_PART=T:
SET PE_SDI_FILE=\boot\boot.sdi
SET PE_WIM_FILE=[T:]\boot\10pex64.wim
SET PE_WIM_BOOT_NAME="Windows 10 PE"

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /create /d %PE_WIM_BOOT_NAME% /device') DO @SET PE_SDI_GUID={%%I}
bcdedit /set %PE_SDI_GUID% ramdisksdidevice partition=%PE_SDI_PART%
bcdedit /set %PE_SDI_GUID% ramdisksdipath %PE_SDI_FILE%

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /create /d %PE_WIM_BOOT_NAME% /application osloader') DO @SET PE_WIM_GUID={%%I}
bcdedit /set %PE_WIM_GUID% device ramdisk=%PE_WIM_FILE%,%PE_SDI_GUID%
bcdedit /set %PE_WIM_GUID% path \Windows\System32\boot\winload.efi
bcdedit /set %PE_WIM_GUID% osdevice ramdisk=%PE_WIM_FILE%,%PE_SDI_GUID%
bcdedit /set %PE_WIM_GUID% systemroot \Windows
bcdedit /set %PE_WIM_GUID% detecthal yes
bcdedit /set %PE_WIM_GUID% winpe yes
bcdedit /displayorder %PE_WIM_GUID% /addlast
bcdedit /enum %PE_WIM_GUID%
```