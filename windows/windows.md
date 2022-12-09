# Windows 10 无人值守安装             
#### MBR 分区         
```bat
rem == CreatePartitions-BIOS.txt ==
select disk 0
clean

rem == 1. System partition ======================
create partition primary size=512
format quick fs=ntfs label="System"
assign letter="S"
active

rem == 2. Create windows partition =====================
create partition primary
shrink minimum=15000
format quick fs=ntfs label="Windows"
assign letter="W"

rem == 3. Create second partition ==============
create partition primary
format quick fs=ntfs label="Data"
assign letter="D"
list volume
exit
```
### Dism 命令安装          
```bat
Dism /Get-ImageInfo /ImageFile:.\install.wim
```
导出wim文件
```bat
Dism /Export-Image /SourceImageFile:.\install.wim /SourceIndex:1 /DestinationImageFile:D:\install.wim
```
安装wim文件到磁盘     
```bat
Dism /Apply-Image /ImageFile:.\install.wim /Index:1 /ApplyDir:C:\
```
挂载镜像       
```bat
MD .\mount
Dism /Mount-Image /ImageFile:.\install.wim /index:1 /MountDir:.\mount
```
添加驱动文件夹           
```bat
Dism /Image:.\mount /Add-Driver /Driver:D:\DriversBackup /Recurse
```
添加无人值守文件             
```bat
MD .\mount\Windows\Panther
COPY Unattend.xml .\mount\Windows\Panther\Unattend.xml
```
```bat
MD .\mount\Windows\Panther
COPY Unattend-x64.xml .\mount\Windows\Panther\Unattend.xml
```
删除 winre.wim 文件       
```bat
attrib -h -s .\mount\Windows\System32\Recovery\Winre.wim
del .\mount\Windows\System32\Recovery\Winre.wim /Q
dir /a .\mount\Windows\System32\Recovery
```
修改 hosts 文件      
```bat
COPY .\mount\Windows\System32\drivers\etc\hosts hosts
COPY hosts .\mount\Windows\System32\drivers\etc\hosts
```
卸载镜像      
```bat
Dism /Unmount-Image /MountDir:.\mount /commit
```
### Bcdboot 命令添加启动项           
```bat
bcdboot C:\Windows /s S: /f UEFI /l en-us
```
```bat
bcdboot C:\Windows /s S: /f BIOS /l en-us
```