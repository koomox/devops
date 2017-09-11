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

将某个驱动器的映像捕捉到新的 .wim 文件。                        
```bat
@echo off
SET N_DRIVE=%~d0
SET N_PATH=%~dp0

SET N_WIM_FILE=WIN7SP2.wim
SET S_DRIVE=C:\
SET N_WIM_NAME="Windows 7 Ultimate SP1 64-bit"
SET N_WIM_TIME="2017-08-20 22:38"

cd "%windir%\DISM"

Dism /Capture-Image /ImageFile:"%N_PATH%%N_WIM_FILE%" /CaptureDir:%S_DRIVE% /Name:%N_WIM_NAME% /Description:%N_WIM_TIME% /Compress:fast
Dism /Get-ImageInfo /ImageFile:"%N_PATH%%N_WIM_FILE%"
pause
```
```bat
Dism /Capture-Image /ImageFile:win7sp2.wim /CaptureDir:C:\ /Name:"Windows 7 Ultimate SP1 64-bit" /Description:"2017-08-20 22:32" /Compress:fast
```

显示 .wim、vhd 或 .vhdx 文件中所含映像的有关信息。                   
```bat
Dism /Get-ImageInfo /ImageFile:install.wim
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