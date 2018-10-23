# 添加 Windows RE 启动项          
### 创建隐藏分区         
`diskmgmt.msc` 打开磁盘管理，鼠标右键点击最后一个分区，选择`压缩卷`，大小输入`1024`，也就是1G容量。给新分区设置卷标`M`盘符      
`diskpart` 管理员模式打开分区工具，把刚才创建的`M`分区设置为隐藏分区。        
```
list disk
select disk 0
select partition 1
format quick fs=ntfs label="RE"
assign letter=M
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
exit
```
### 复制文件到隐藏分区            
可用的wim文件有两个，`*.iso\sources\boot.wim`或`*.iso\sources\install.wim\Windows\System32\Recovery\winre.wim`文件，以及`*.iso\boot\boot.sdi`文件。复制到`M:\Recovery\WindowsRE\`文件夹。          
首先查看WIM镜像文件详细信息          
```
SET DISM_PATH=F:\RecoveryImage\PE_Tools\Windows_10_version_1607_Kits\Deployment_Tools\amd64\DISM
SET WIM_FILE=F:\RecoveryImage\10\x64\install.wim

cd /d %DISM_PATH%

Dism /Get-ImageInfo /ImageFile:"%WIM_FILE%"
```
挂载WIM镜像文件            
```
SET WIM_FILE=F:\RecoveryImage\10\x64\install.wim
SET WIM_INDEX=2
SET WIM_MOUNTPATH=D:\mount\win10

Dism /Mount-Wim /WimFile:%WIM_FILE% /Index:%WIM_INDEX% /MountDir:%WIM_MOUNTPATH%
```
复制文件到隐藏分区           
```
SET RE_DRIVE=M:
SET WIM_MOUNTPATH=D:\mount\win10

rmdir /S /Q "%RE_DRIVE%\Recovery"
mkdir "%RE_DRIVE%\Recovery"
mkdir "%RE_DRIVE%\Recovery\WindowsRE\"
xcopy %WIM_MOUNTPATH%\Windows\System32\boot.sdi "%RE_DRIVE%\Recovery\WindowsRE\" /H /K /Y
xcopy %WIM_MOUNTPATH%\Windows\System32\Recovery\winre.wim "%RE_DRIVE%\Recovery\WindowsRE\" /H /K /Y

cd /d "%RE_DRIVE%\Recovery\WindowsRE\"
dir /a
```
卸载WIM镜像文件          
```
SET WIM_MOUNTPATH=D:\mount\win10
Dism /Unmount-Wim /MountDir:%WIM_MOUNTPATH% /Discard
```
### 把 Windows RE 系统添加到系统启动项              
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
SET SDI_PART=M:
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
SET WIM_FILE=[M:]\Recovery\WindowsRE\winre.wim

bcdedit /set %WIM_GUID% device ramdisk=%WIM_FILE%,%SDI_GUID%
bcdedit /set %WIM_GUID% path \Windows\System32\winload.efi
bcdedit /set %WIM_GUID% osdevice ramdisk=%WIM_FILE%,%SDI_GUID%
bcdedit /set %WIM_GUID% systemroot \Windows
bcdedit /set %WIM_GUID% detecthal yes
bcdedit /set %WIM_GUID% winpe yes
bcdedit /displayorder %WIM_GUID% /addlast
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