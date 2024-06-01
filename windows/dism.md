# DISM                 
### bcdboot                
BCDBoot 命令行选项: [传送门](https://msdn.microsoft.com/zh-cn/library/windows/hardware/dn898490(v=vs.85).aspx)                 
Bcdedit 命令行选项: [传送门](https://technet.microsoft.com/zh-cn/library/cc731662.aspx)            
Bootsect 命令行选项: [传送门](https://msdn.microsoft.com/zh-cn/library/windows/hardware/dn898493(v=vs.85).aspx)                

创建 UEFI 启动文件到 EFI 启动分区              
```bat
bcdboot C:\Windows /s U: /f UEFI /l zh-cn
```

创建 BIOS 和 UEFI 启动文件到系统分区                  
```bat
bcdboot C:\Windows /s C: /f ALL /l zh-cn
```
### dism             
DISM 命令行选项: [传送门](https://technet.microsoft.com/zh-cn/library/hh825258.aspx)            
Dism 完整版: [点击下载](/storage/windows/deploy/DeploymentTools.7z)        

将某个驱动器的映像捕捉到新的 .wim 文件。                        
```bat
@echo off
SET N_DRIVE=%~d0
SET N_PATH=%~dp0

SET N_WIM_FILE=WIN7SP2.wim
SET S_DRIVE=C:\
SET N_WIM_NAME="Windows 7 Ultimate SP1 64-bit"
SET N_WIM_TIME="2017-08-20 22:38"

Dism /Capture-Image /ImageFile:"%N_PATH%%N_WIM_FILE%" /CaptureDir:%S_DRIVE% /Name:%N_WIM_NAME% /Description:%N_WIM_TIME% /Compress:fast
Dism /Get-ImageInfo /ImageFile:"%N_PATH%%N_WIM_FILE%"
pause
```
```bat
Dism /Capture-Image /ImageFile:D:\RecoveryImage\win7sp2.wim /CaptureDir:C:\ /Name:"Windows 7 Ultimate SP1 64-bit" /Description:"2017-08-20 22:32" /Compress:fast
```

显示 .wim、vhd 或 .vhdx 文件中所含映像的有关信息。                   
```bat
Dism /Get-ImageInfo /ImageFile:.\install.wim
```

将 Windows 映像从 .vim 或 .vhdx 文件装载到指定的目录，以便可对其进行处理。                  
```bat
Dism /Mount-Image /ImageFile:install.wim /Index:4 /MountDir:D:\mount\win7 /ReadOnly
```               

卸载 .wim、.vhd 或 .vhdx文件并提交或放弃装载映像时所做的更改。在使用 `/Unmount-Image` 选项时，必须使用 `/commit` 或 `/discard` 参数。            
```bat
Dism /Unmount-Image /MountDir:C:\test\offline /commit
Dism /Unmount-Image /MountDir:C:\test\offline /discard
```

将映像应用于指定的驱动器。             
```bat
Dism /Apply-Image /ImageFile:install.wim /Index:1 /ApplyDir:D:\
```

将附加映像添加到 .wim 文件中。`/AppendImage` 用于对比新文件与由 `/ImageFile` 参数指定的现有 .vim 文件中的资源，并仅存储各个唯一的文件的单份拷贝，从而使得每个文件仅被捕捉一次。.wim 文件可以仅具有一个分配的压缩类型。因此，你可以仅附加具有相同压缩类型的文件。                   
```bat
Dism /Append-Image /ImageFile:install.wim /CaptureDir:D:\ /Name:Drive-D
```
### Dism 备份和还原驱动          
在D盘创建 `DriversBackup` 文件夹 `MD D:\DriversBackup`          
将当前系统驱动备份到 `D:\DriversBackup` 目录下。           
```bat
DISM /Online /Export-Driver /Destination:D:\DriversBackup
```
还原驱动。           
```bat
DISM /Online /Add-Driver /Driver:D:\DriversBackup /Recurse
```
### 使用完整版 Dism          
Windows 7 系统中的 Dism 不完整很多功能无法使用。可以从Windows ADK 中提取出完整版的 Dism。          
`DandIRoot` 变量就是DeploymentTools的路径，如此就可以使用完整版的 Dism 了。       
使用完整版 Dism: [点击查看源文件](/storage/windows/scripts/dism/DISM-ENV.bat)           
```
IF /I %PROCESSOR_ARCHITECTURE%==x86 (
    IF NOT "%PROCESSOR_ARCHITEW6432%"=="" (
        SET PROCESSOR_ARCHITECTURE=%PROCESSOR_ARCHITEW6432%
    )
) ELSE IF /I NOT %PROCESSOR_ARCHITECTURE%==amd64 (
    @echo Not implemented for PROCESSOR_ARCHITECTURE of %PROCESSOR_ARCHITECTURE%.
    @echo Using "%ProgramFiles%"
    
    SET NewPath="%ProgramFiles%"

    goto SetPath
)

SET ScriptPath=%~dp0
SET DandIRoot=%ScriptPath%\DeploymentTools
SET DISMRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\DISM
SET BCDBootRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\BCDBoot
SET NewPath=%DISMRoot%;%BCDBootRoot%

:SetPath
SET PATH=%NewPath:"=%;%PATH%

cd /d %~dp0
cls
```
### Dism 提取WIM镜像、添加驱动等          
显示 .wim、vhd 或 .vhdx 文件中所含映像的有关信息。                   
```bat
Dism /Get-ImageInfo /ImageFile:.\install.wim
```
从 `install.wim` 文件中提取索引4的镜像，保存为 `win7sp1-Ultimate-x64.wim`
```bat
Dism /Export-Image /SourceImageFile:.\install.wim /SourceIndex:4 /DestinationImageFile:win7sp1-Ultimate-x64.wim
```
从 `D:\DriversBackup` 添加驱动到离线镜像             
```bat
Dism /Image:.\mount /Add-Driver /Driver:D:\DriversBackup /Recurse
```
把无人值守文件 `Unattend.xml` 复制到 `\Windows\Panther` 目录下         
```bat
MD .\mount\Windows\Panther
COPY Unattend-x64.xml .\mount\Windows\Panther\Unattend.xml
```
卸载镜像并提交所做的修改           
```bat
Dism /Unmount-Image /MountDir:.\mount /Commit
```
```bat
Dism /Get-ImageInfo /ImageFile:E:\sources\install.wim
Dism /Export-Image /SourceImageFile:E:\sources\install.wim /SourceIndex:4 /DestinationImageFile:D:\win11_optimize.wim
Dism /Image:.\mount /Add-Driver /Driver:D:\DriversBackup /Recurse
MD .\mount\Windows\Panther
COPY Unattend-x64.xml .\mount\Windows\Panther\Unattend.xml
Dism /Mount-Image /ImageFile:.\install.wim /Index:1 /MountDir:.\mount
Dism /Unmount-Image /MountDir:.\mount /Commit
::Dism /Unmount-Image /MountDir:.\mount /Discard
```
### Drivers         
```bat
Dism /Image:.\mount /Add-Driver /Driver:D:\DriversBackup /Recurse
```
```bat
Dism /Online /Add-Driver /Driver:D:\DriversBackup /Recurse
```
### WIMBOOT              
导出镜像并添加驱动、无人值守、hosts 文件            
```bat
Dism /Get-ImageInfo /ImageFile:E:\sources\install.wim
Dism /Export-Image /SourceImageFile:E:\sources\install.wim /SourceIndex:1 /DestinationImageFile:D:\en_win10_ltsc_2019_x64.wim

Dism /Mount-Image /ImageFile:.\en_win10_ltsc_2019_x64.wim /Index:1 /MountDir:.\mount

rmdir mount
mkdir mount
Dism /Image:.\mount /Add-Driver /Driver:D:\DriversBackup /Recurse

MD .\mount\Windows\Panther
COPY Unattend-x64.xml .\mount\Windows\Panther\Unattend.xml

COPY .\mount\Windows\System32\drivers\etc\hosts hosts
COPY hosts .\mount\Windows\System32\drivers\etc\hosts

attrib -h -s .\mount\Windows\System32\Recovery\Winre.wim
del .\mount\Windows\System32\Recovery\Winre.wim /Q
dir /a .\mount\Windows\System32\Recovery

Dism /Unmount-Image /MountDir:.\mount /Commit
```
安装 .Net3.5          
```bat
Dism /Image:.\mount /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:F:\sources\sxs
Dism /Image:.\mount /Get-FeatureInfo /FeatureName:NetFx3

Dism /Image:.\mount /Disable-Feature /FeatureName:NetFx3 /Remove

Dism /online /Get-FeatureInfo /FeatureName:NetFx3
```
构造并部署 wimboot, wimboot 文件存放在SSD硬盘隐藏分区        
```bat
Dism /Export-Image /SourceImageFile:.\install.wim /SourceIndex:1 /DestinationImageFile:.\en_win10_ltsc_2019_x64_boot.wim /WIMBoot
Dism /Apply-Image /ImageFile:.\en_win10_ltsc_2019_x64_boot.wim /ApplyDir:C:\ /Index:1 /WIMBoot
```
### bcdedit         
添加 VHD 启动项 [source](/storage/windows/deploy/add_vhd.bat)         
```bat
SET VHD_GUID={}
SET VHD_BOOT_NAME="Windows 10 VHD"

FOR /F "tokens=2 delims={,}" %I IN ('bcdedit /copy {current} /d %VHD_BOOT_NAME%') DO @SET VHD_GUID={%I}
bcdedit /set %VHD_GUID% device vhd="[R:]\VHD\win10.vhd"
bcdedit /set %VHD_GUID% osdevice vhd="[R:]\VHD\win10.vhd"
bcdedit /set %VHD_GUID% detecthal Yes
bcdedit /displayorder %VHD_GUID% /addlast
```
添加 pe.wim 启动项 [source](/storage/windows/deploy/add_pe.bat)        
```bat
SET PE_SDI_GUID={}
SET PE_WIM_GUID={}
SET PE_SDI_PART=T:
SET PE_SDI_FILE=\BOOT\BOOT.sdi
SET PE_WIM_FILE=[T:]\BOOT\10PEx64.wim
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
#### KMS        
第一条命令是添加排除文件          
第二条复制vlmcsd到system32目录          
第三条安装kms-server服务          
```bat
Add-MpPreference -ExclusionProcess "%SystemRoot%\System32\kms-server.exe" -Force
COPY vlmcsd-Windows-x64.exe %SystemRoot%\System32\kms-server.exe
%SystemRoot%\System32\kms-server.exe -s
```