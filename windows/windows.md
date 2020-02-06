# Windows 10 无人值守安装             
#### UEFI 分区         
```bat
rem == CreatePartitions-UEFI.txt ==
select disk 0
clean
convert gpt

rem == 1. Windows RE tools partition ===============
create partition primary size=1024
format quick fs=ntfs label="Windows RE tools"
assign letter="T"
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001

rem == 2. System partition =========================
create partition efi size=500
format quick fs=fat32 label="System"
assign letter="S"

rem == 3. Microsoft Reserved (MSR) partition =======
create partition msr size=128

rem == 4. Windows partition ========================
create partition primary
shrink minimum=15000
format quick fs=ntfs label="Windows"
assign letter="C"

rem === 5. Recovery Second partition ================
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
bcdboot C:\Windows /s S: /f UEFI /l en-us
```