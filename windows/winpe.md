# 添加 Windows PE 启动项         
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
将 PE 添加到启动项 [source](/storage/windows/deploy/add_pe.bat)           
```
SET PE_SDI_GUID={}
SET PE_WIM_GUID={}
SET PE_SDI_PART=T:
SET PE_SDI_FILE=\boot\boot.sdi
SET PE_WIM_FILE=[T:]\boot\10pex64.wim
SET PE_WIM_BOOT_NAME="Windows PE"

FOR /F "tokens=2 delims={,}" %I IN ('bcdedit /create /d %PE_WIM_BOOT_NAME% /device') DO @SET PE_SDI_GUID={%I}
bcdedit /set %N_SDI_GUID% ramdisksdidevice partition=%N_SDI_PART%
bcdedit /set %N_SDI_GUID% ramdisksdipath %N_SDI_FILE%

FOR /F "tokens=2 delims={,}" %I IN ('bcdedit /create /d %PE_WIM_BOOT_NAME% /application osloader') DO @SET PE_WIM_GUID={%I}
bcdedit /set %N_WIM_GUID% device ramdisk=%N_WIM_FILE%,%N_SDI_GUID%
bcdedit /set %N_WIM_GUID% path \Windows\System32\boot\winload.efi
bcdedit /set %N_WIM_GUID% osdevice ramdisk=%N_WIM_FILE%,%N_SDI_GUID%
bcdedit /set %N_WIM_GUID% systemroot \Windows
bcdedit /set %N_WIM_GUID% detecthal yes
bcdedit /set %N_WIM_GUID% winpe yes
bcdedit /displayorder %N_WIM_GUID% /addlast
bcdedit /enum %N_WIM_GUID%
```