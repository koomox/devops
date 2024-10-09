# Windows RE          
### 创建隐藏分区         
`diskmgmt.msc` 打开磁盘管理，鼠标右键点击最后一个分区，选择`压缩卷`，大小输入`1024`，也就是1G容量。给新分区设置卷标`M`盘符      
`diskpart` 管理员模式打开分区工具，把刚才创建的`M`分区设置为隐藏分区。        
#### CreatePartitions-UEFI.txt          
```txt
rem == CreatePartitions-UEFI.txt ==
rem == These commands are used with DiskPart to
rem    create four partitions
rem    for a UEFI/GPT-based PC.
rem    Adjust the partition sizes to fill the drive
rem    as necessary. ==
select disk 0
clean
convert gpt
rem == 1. Windows RE tools partition ===============
create partition primary size=2000
format quick fs=ntfs label="Windows RE tools"
assign letter="T"
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
rem == 2. System partition =========================
create partition efi size=500
rem ** NOTE: For Advanced Format 4Kn drives,
rem          change this value to size = 260 **
format quick fs=fat32 label="System"
assign letter="S"
rem == 3. Microsoft Reserved (MSR) partition =======
create partition msr size=128
rem == 4. Windows partition ========================
rem ==    a. Create the Windows partition ==========
create partition primary 
rem ==    b. Create space for the recovery image ===
shrink minimum=15000
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
### 复制文件到隐藏分区            
可用的wim文件有两个，`*.iso\sources\boot.wim`或`*.iso\sources\install.wim\Windows\System32\Recovery\winre.wim`文件，以及`*.iso\boot\boot.sdi`文件。复制到`T:\RecoveryImage\RE\`文件夹。          
```bat
mkdir mount

Dism /Mount-Wim /WimFile:.\install.wim /Index:1 /MountDir:.\mount

xcopy /h .\mount\Windows\System32\Recovery\Winre.wim .\

Dism /Unmount-Image /MountDir:.\mount /Discard
```
首先查看WIM镜像文件详细信息          
```
Dism /Get-ImageInfo /ImageFile:.\Winre.wim
```
复制到 RE 分区       
```bat
mkdir T:\RecoveryImage\RE

xcopy /h .\Winre.wim T:\RecoveryImage\RE
```
挂载WIM镜像文件            
```
mkdir mount
Dism /Mount-Wim /WimFile:.\Winre.wim /Index:2 /MountDir:.\mount
```
复制文件到隐藏分区           
```bat
SET RE_DRIVE=T:
SET WIM_MOUNTPATH=D:\mount

rmdir /S /Q "%RE_DRIVE%\RecoveryImage"
mkdir "%RE_DRIVE%\RecoveryImage"
mkdir "%RE_DRIVE%\RecoveryImage\RE\"
xcopy %WIM_MOUNTPATH%\Windows\System32\boot.sdi "%RE_DRIVE%\RecoveryImage\RE\" /H /K /Y
xcopy %WIM_MOUNTPATH%\Windows\System32\Recovery\winre.wim "%RE_DRIVE%\RecoveryImage\RE\" /H /K /Y

cd /d "%RE_DRIVE%\RecoveryImage\RE\"
dir /a
```
卸载WIM镜像文件          
```
Dism /Unmount-Wim /MountDir:".\mount" /Discard
```
### 把 Windows RE 系统添加到系统启动项 [source](/storage/windows/deploy/add_re.bat)             
```bat
SET RE_SDI_GUID={}
SET RE_WIM_GUID={}
SET RE_SDI_PART=T:
SET RE_SDI_FILE=\RecoveryImage\RE\boot.sdi
SET RE_WIM_FILE=[T:]\RecoveryImage\RE\Winre.wim
SET RE_WIM_BOOT_NAME="Windows RE"

FOR /F "tokens=2 delims={,}" %I IN ('bcdedit /create /d %RE_WIM_BOOT_NAME% /device') DO @SET RE_SDI_GUID={%I}
bcdedit /set %RE_SDI_GUID% ramdisksdidevice partition=%RE_SDI_PART%
bcdedit /set %RE_SDI_GUID% ramdisksdipath %RE_SDI_FILE%

FOR /F "tokens=2 delims={,}" %I IN ('bcdedit /create /d %RE_WIM_BOOT_NAME% /application osloader') DO @SET RE_WIM_GUID={%I}
bcdedit /set %RE_WIM_GUID% device ramdisk=%RE_WIM_FILE%,%RE_SDI_GUID%
bcdedit /set %RE_WIM_GUID% path \Windows\System32\boot\winload.efi
bcdedit /set %RE_WIM_GUID% osdevice ramdisk=%RE_WIM_FILE%,%RE_SDI_GUID%
bcdedit /set %RE_WIM_GUID% systemroot \Windows
bcdedit /set %RE_WIM_GUID% detecthal yes
bcdedit /set %RE_WIM_GUID% winpe yes
bcdedit /displayorder %RE_WIM_GUID% /addlast
bcdedit /enum %RE_WIM_GUID%
```
### 隐藏 Windows RE 分区        
```
list disk
select disk 0
select partition 1
remove
exit
```
### 删除启动项            
```
SET SDI_GUID={36d941ca-937f-47f3-829c-7b45addb8a0c}
SET WIM_GUID={807e1a98-9ec4-41fd-a2d2-d128d6723a00}

bcdedit /delete %WIM_GUID% /cleanup
bcdedit /delete %SDI_GUID% /cleanup
```
### 设置选择操作系统系列的等待时间            
设置为 5 秒          
```
bcdedit /timeout 5
```

#### bcdedit       
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
```