# 添加 Windows PE 启动项         
Windows PE 下载: [传送门](https://go.microsoft.com/fwlink/?linkid=2196224)             
Windows 11 Version 22H2 ADK 评估和部署工具包: [传送门](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install) [点击下载](https://go.microsoft.com/fwlink/?linkid=2196127)      
加载ISO光盘映像文件，查看 `sources\boot.wim` 映像文件详细信息           
```
SET WIM_FILE=V:\sources\boot.wim

Dism /Get-ImageInfo /ImageFile:%WIM_FILE%
```
从 boot.wim 映像中导出索引1的映像文件。
```
Dism /Export-Image /SourceImageFile:"V:\sources\boot.wim" /SourceIndex:1 /DestinationImageFile:10PEX64.wim /DestinationName:"Windows 11 PE"
```
挂载WIM镜像文件          
```
Dism /Mount-Wim /WimFile:F:\RecoveryImage\10PEX64.wim /Index:1 /MountDir:.\mount
```
将 PE 添加到启动项 [source](/storage/windows/deploy/add_pe.bat)           
```
SET PE_SDI_GUID={}
SET PE_WIM_GUID={}
SET PE_SDI_PART=T:
SET PE_SDI_FILE=\boot\boot.sdi
SET PE_WIM_FILE=[T:]\boot\10PEX64.wim
SET PE_WIM_BOOT_NAME="Windows PE"

FOR /F "tokens=2 delims={,}" %I IN ('bcdedit /create /d %PE_WIM_BOOT_NAME% /device') DO @SET PE_SDI_GUID={%I}
bcdedit /set %PE_SDI_GUID% ramdisksdidevice partition=%PE_SDI_PART%
bcdedit /set %PE_SDI_GUID% ramdisksdipath %PE_SDI_FILE%

FOR /F "tokens=2 delims={,}" %I IN ('bcdedit /create /d %PE_WIM_BOOT_NAME% /application osloader') DO @SET PE_WIM_GUID={%I}
bcdedit /set %PE_WIM_GUID% device ramdisk=%PE_WIM_FILE%,%PE_SDI_GUID%
bcdedit /set %PE_WIM_GUID% path \Windows\System32\boot\winload.efi
bcdedit /set %PE_WIM_GUID% osdevice ramdisk=%PE_WIM_FILE%,%PE_SDI_GUID%
bcdedit /set %PE_WIM_GUID% systemroot \Windows
bcdedit /set %PE_WIM_GUID% detecthal yes
bcdedit /set %PE_WIM_GUID% winpe yes
bcdedit /displayorder %PE_WIM_GUID% /addlast
bcdedit /enum %PE_WIM_GUID%
```