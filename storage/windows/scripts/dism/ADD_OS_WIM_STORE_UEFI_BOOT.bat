@echo off
SET N_DRIVE=%~d0
SET N_PATH=%~dp0

SET N_BOOT_A="M:\Windows"
SET N_BOOT_B="N:\Windows"
SET N_BOOT_C="C:\Windows"
SET N_EFI_PART=U:
SET N_BCD_FILE="U:\EFI\Microsoft\Boot\BCD"

SET N_SDI_GUID={09c8e065-e68b-4710-aafd-dfd4a13f1f56}
SET N_WIM_GUID={8d7554da-1df1-4d98-afc4-efc6ff51434c}
SET N_SDI_PART=R:
SET N_SDI_FILE=\Recovery\WindowsPE\USBZL.SDI
SET N_WIM_FILE=[R:]\Recovery\WindowsPE\NT63PEX64.WIM
SET N_WIM_BOOT_NAME="Windows PE"

%N_DRIVE%
cd "%N_DRIVE%\RecoveryImage\PE_Tools\10\Deployment_Tools\amd64\BCDBoot"

bcdboot %N_BOOT_A% /s %N_EFI_PART% /f UEFI /l zh-cn
bcdboot %N_BOOT_B% /s %N_EFI_PART% /f UEFI /l zh-cn
bcdboot %N_BOOT_C% /s %N_EFI_PART% /f UEFI /l zh-cn
bcdedit /store %N_BCD_FILE% /create %N_SDI_GUID% /device
bcdedit /store %N_BCD_FILE% /set %N_SDI_GUID% ramdisksdidevice partition=%N_SDI_PART%
bcdedit /store %N_BCD_FILE% /set %N_SDI_GUID% ramdisksdipath %N_SDI_FILE%

bcdedit /store %N_BCD_FILE% /create %N_WIM_GUID% /d %N_WIM_BOOT_NAME% /application osloader
bcdedit /store %N_BCD_FILE% /set %N_WIM_GUID% device ramdisk=%N_WIM_FILE%,%N_SDI_GUID%
bcdedit /store %N_BCD_FILE% /set %N_WIM_GUID% path \Windows\System32\winload.efi
bcdedit /store %N_BCD_FILE% /set %N_WIM_GUID% osdevice ramdisk=%N_WIM_FILE%,%N_SDI_GUID%
bcdedit /store %N_BCD_FILE% /set %N_WIM_GUID% systemroot \Windows_FILE
bcdedit /store %N_BCD_FILE% /set %N_WIM_GUID% detecthal yes
bcdedit /store %N_BCD_FILE% /set %N_WIM_GUID% winpe yes
bcdedit /store %N_BCD_FILE% /displayorder %N_WIM_GUID% /addlast
bcdedit /store %N_BCD_FILE% /enum
pause