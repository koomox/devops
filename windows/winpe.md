# Windows PE         
Windows ADK: [Link](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install)             
Windows Assessment and Deployment Kit (Windows ADK) [Link](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install)        
Windows PE add-on for the Windows ADK [Link](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install)           
AnyBurn [Link](https://www.anyburn.com/index.htm)          
Deployment lab sample scripts [Link](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/oem-deployment-of-windows-desktop-editions-sample-scripts?view=windows-11)                   
Hiren's BootCD PE [Link](https://www.hirensbootcd.org/)            
#### Create bootable Windows PE media            
1.Make sure your PC has the ADK and ADK Windows PE add-on installed.      
- Windows Assessment and Deployment Kit (Windows ADK) [Link](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install)        
- Windows PE add-on for the Windows ADK [Link](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install)           

2.Start the Deployment and Imaging Tools Environment as an administrator.          
3.Run copype to create a working copy of the Windows PE files. For more information about copype         
```
copype amd64 C:\WinPE_amd64
```
4.Use MakeWinPEMedia with the /ISO option to create an ISO file containing the Windows PE files:           
```
MakeWinPEMedia /ISO C:\WinPE_amd64 C:\WinPE_amd64\WinPE_amd64.iso
```
#### CreatePartitions-UEFI.txt          
```txt
rem == CreatePartitions-UEFI.txt ==
select disk 0
clean
convert gpt
rem == 1. System partition =========================
create partition efi size=500
rem    ** NOTE: For Advanced Format 4Kn drives,
rem               change this value to size = 260 ** 
format quick fs=fat32 label="System"
assign letter="S"
rem == 2. Microsoft Reserved (MSR) partition =======
create partition msr size=128
rem == 3. Windows partition ========================
create partition primary  
format quick fs=ntfs label="Windows"
assign letter="W"
list volume
exit
```
#### setup.cmd        
```
diskpart /s CreatePartitions-UEFI.txt
dism /Apply-Image /ImageFile:install.wim /Index:1 /ApplyDir:W:\
MD W:\Windows\Panther
COPY /Y Unattend.xml W:\Windows\Panther\Unattend.xml
bcdboot W:\Windows /s S:
```
#### Unattend.xml            
```
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <AutoLogon>
                <Enabled>true</Enabled>
                <LogonCount>1</LogonCount>
                <Username>Administrator</Username>
            </AutoLogon>
            <LogonCommands>
                <AsynchronousCommand wcm:action="add">
                    <Description>Enable Admin AutoLogin</Description>
                    <Order>1</Order>
                    <CommandLine>reg add &quot;HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon&quot; /v AutoLogonCount /t REG_DWORD /d 0 /f</CommandLine>
                </AsynchronousCommand>
            </LogonCommands>
            <OOBE>
                <SkipUserOOBE>true</SkipUserOOBE>
                <SkipMachineOOBE>true</SkipMachineOOBE>
                <ProtectYourPC>1</ProtectYourPC>
                <NetworkLocation>Work</NetworkLocation>
            </OOBE>
            <RegisteredOrganization>Dev.Inc</RegisteredOrganization>
            <RegisteredOwner>Dev</RegisteredOwner>
            <TimeZone>China Standard Time</TimeZone>
        </component>
        <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <UserLocale>en-US</UserLocale>
            <InputLocale>en-US</InputLocale>
            <SystemLocale>en-US</SystemLocale>
            <UILanguage>en-US</UILanguage>
            <UILanguageFallback>en-US</UILanguageFallback>
        </component>
    </settings>
</unattend>
```
#### imagefile info         
```
Dism /Get-ImageInfo /ImageFile:E:\sources\install.wim
```
#### convert esd to wim    
```
dism /Get-WimInfo /WimFile:E:\sources\install.esd
```
```
dism /export-image /SourceImageFile:I:\sources\install.esd /SourceIndex:1 /DestinationImageFile:F:\install.wim /Compress:max /CheckIntegrity
```
#### export wim              
加载ISO光盘映像文件，查看 `sources\boot.wim` 映像文件详细信息            
```
Dism /Get-ImageInfo /ImageFile:E:\sources\boot.wim
```
从 boot.wim 映像中导出索引1的映像文件。
```
Dism /Export-Image /SourceImageFile"I:\sources\boot.wim /SourceIndex:1 /DestinationImageFile:10PEX64.wim /DestinationName:"Windows PE"
```
挂载WIM镜像文件          
```
Dism /Mount-Wim /WimFile:10PEX64.wim /Index:1 /MountDir:.\mount
```
##### 复制文件到隐藏分区            
可用的wim文件有两个，`*.iso\sources\boot.wim`或`*.iso\sources\install.wim\Windows\System32\Recovery\winre.wim`文件，以及`*.iso\boot\boot.sdi`文件。复制到`T:\Recovery\WindowsRE\`文件夹。          
首先查看WIM镜像文件详细信息          
```
Dism /Get-ImageInfo /ImageFile:.\install.wim
```
挂载WIM镜像文件            
```
Dism /Mount-Wim /WimFile:%WIM_FILE% /Index:%WIM_INDEX% /MountDir:%WIM_MOUNTPATH%
```
复制文件到隐藏分区           
```
rmdir /S /Q R:\Recovery
mkdir R:\Recovery
mkdir R:\Recovery\WindowsRE\
xcopy .\mount\Windows\System32\boot.sdi R:\Recovery\WindowsRE\ /H /K /Y
xcopy .\mount\Windows\System32\Recovery\winre.wim R:\Recovery\WindowsRE\ /H /K /Y

cd /d R:\Recovery\WindowsRE\
dir /a
```
卸载WIM镜像文件          
```
Dism /Unmount-Wim /MountDir:.\mount /Discard
```
#### 启动项            
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
#### Enable administrator account in Windows 10               
1. Press [Shift] + [F10] simultaneously to run the Windows Command Processor             
2. Type the Windows CMD command "net user administrator /active:yes" and press [Enter]. The Windows 10 administrator account is now enabled.       
```
net user administrator /active:yes
```
3.Press [Ctrl] + [Shift] + [F3] reboot computer.       
#### bcdedit        
```
SET PE_SDI_GUID={}
SET PE_WIM_GUID={}
SET PE_SDI_PART=T:
SET PE_SDI_FILE=\boot\boot.sdi
SET PE_WIM_FILE=[T:]\boot\10pex64.wim
SET PE_WIM_BOOT_NAME="Windows 10 PE"

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /create /d %PE_WIM_BOOT_NAME% /device') DO @SET PE_SDI_GUID={%%I}
bcdedit /set %PE_SDI_GUID% ramdisksdidevice partition=%PE_SDI_PART%
bcdedit /set %PE_SDI_GUID% ramdisksdipath %PE_SDI_FILE%

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /create /d %PE_WIM_BOOT_NAME% /application osloader') DO @SET PE_WIM_GUID={%%I}
bcdedit /set %PE_WIM_GUID% device ramdisk=%PE_WIM_FILE%,%PE_SDI_GUID%
bcdedit /set %PE_WIM_GUID% path \Windows\System32\boot\winload.efi
bcdedit /set %PE_WIM_GUID% osdevice ramdisk=%PE_WIM_FILE%,%PE_SDI_GUID%
bcdedit /set %PE_WIM_GUID% systemroot \Windows
bcdedit /set %PE_WIM_GUID% detecthal yes
bcdedit /set %PE_WIM_GUID% winpe yes
bcdedit /displayorder %PE_WIM_GUID% /addlast
bcdedit /enum %PE_WIM_GUID%
```