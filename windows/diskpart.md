# Diskpart                       
参考文档: [传送门](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/hh825686(v=win.10))       
部署参考文档: [传送门](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions)           

### UEFI/GPT 分区          
使用 `DiskPart /s F:\CreatePartitions.txt` 命令自动分区。          
![](/static/images/wiki/IMG_20180915_212100.jpg)         
```bat
select disk 0
clean
convert gpt
create partition primary size=300
format quick fs=ntfs label="Windows RE tools"
assign letter="T"
create partition efi size=100
rem == Note: for Advanced Format Generation One drives, change to size=260.

format quick fs=fat32 label="System"
assign letter="S"
create partition msr size=128
create partition primary
format quick fs=ntfs label="Windows"
assign letter="W"
```
![](/static/images/wiki/IMG_20180915_212101.jpg)       
```bat
rem == CreatePartitions-UEFI.txt ==
rem == These commands are used with DiskPart to
rem    create five partitions
rem    for a UEFI/GPT-based PC.
rem    Adjust the partition sizes to fill the drive
rem    as necessary. ==
select disk 0
clean
convert gpt
rem == 1. Windows RE tools partition ===============
create partition primary size=300
format quick fs=ntfs label="Windows RE tools"
assign letter="T"
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
rem == 2. System partition =========================
create partition efi size=100
rem    ** NOTE: For Advanced Format 4Kn drives,
rem               change this value to size = 260 ** 
format quick fs=fat32 label="System"
assign letter="S"
rem == 3. Microsoft Reserved (MSR) partition =======
create partition msr size=128
rem == 4. Windows partition ========================
rem ==    a. Create the Windows partition ==========
create partition primary 
rem ==    b. Create space for the recovery image ===
shrink minimum=15000
rem       ** NOTE: Update this size to match the size
rem                of the recovery image           **
rem ==    c. Prepare the Windows partition ========= 
format quick fs=ntfs label="Windows"
assign letter="W"
rem === 5. Recovery image partition ================
create partition primary
format quick fs=ntfs label="Recovery image"
assign letter="R"
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
list volume
exit
```
### BIOS/MBR 分区         
![](/static/images/wiki/IMG_20180915_212102.jpg)         
```bat
select disk 0
clean
create partition primary size=350
format quick fs=ntfs label="System"
assign letter="S"
create partition primary
format quick fs=ntfs label="Windows"
assign letter="W"
exit
```
![](/static/images/wiki/IMG_20180915_212103.jpg)       
```bat
rem == CreatePartitions-BIOS.txt ==
rem == These commands are used with DiskPart to
rem    create three partitions
rem    for a BIOS/MBR-based computer.
rem    Adjust the partition sizes to fill the drive
rem    as necessary. ==
select disk 0
clean
rem == 1. System partition ======================
create partition primary size=350
format quick fs=ntfs label="System"
assign letter="S"
active
rem == 2. Windows partition =====================
rem ==    a. Create the Windows partition =======
create partition primary
rem ==    b. Create space for the recovery image  
shrink minimum=15000
rem          ** Note, adjust the size to match
rem             the size of the recovery image.
rem ==    c. Prepare the Windows partition ====== 
format quick fs=ntfs label="Windows"
assign letter="W"
rem == 3. Recovery image partition ==============
create partition primary
format quick fs=ntfs label="Recovery image"
assign letter="R"
set id=27
list volume
exit
```
配置 4 个以上分区，使用命令 `DiskPart /s F:\PrepareMyPartitions.txt` 自动分区。          
![](/static/images/wiki/IMG_20180915_212105.jpg)       
```bat
select disk 0
clean
create partition primary size=100
format quick fs=ntfs label="Utility1"
assign letter="U"
set id=27
create partition primary size=200
format quick fs=ntfs label="Utility2"
assign letter="V"
set id=27
create partition primary size=100
format quick fs=ntfs label="System"
assign letter="S"
active
create partition extended
create partition logical size=75000
format quick fs=ntfs label="Windows"
assign letter="W"
create partition logical
format quick fs=ntfs label="Recovery image"
assign letter="R"
set id=27
exit
```