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
assign letter="C"

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

Dism /Apply-Image /ImageFile:.\install.wim /Index:1 /ApplyDir:C:\

MD C:\Windows\Panther
COPY Unattend.xml C:\Windows\Panther\Unattend.xml
```
### Bcdboot 命令添加启动项           
```bat
bcdboot C:\Windows /s S: /f BIOS /l en-us
```