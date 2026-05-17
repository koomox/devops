@echo off
SET N_DRIVE=%~d0
SET N_PATH=%~dp0
SET N_SDI_GUID={09c8e065-e68b-4710-aafd-dfd4a13f1f56}
SET N_WIM_GUID={8d7554da-1df1-4d98-afc4-efc6ff51434c}
SET N_SDI_PART=R:
SET N_SDI_FILE=\Recovery\WindowsPE\USBZL.SDI
SET N_WIM_FILE=[R:]\Recovery\WindowsPE\NT63PEX64.WIM
SET N_WIM_BOOT_NAME="Windows PE"
cd "%windir%\BCDBoot"
bcdedit /create %N_SDI_GUID% /device
bcdedit /set %N_SDI_GUID% ramdisksdidevice partition=%N_SDI_PART%
bcdedit /set %N_SDI_GUID% ramdisksdipath %N_SDI_FILE%

bcdedit /create %N_WIM_GUID% /d %N_WIM_BOOT_NAME% /application osloader
bcdedit /set %N_WIM_GUID% device ramdisk=%N_WIM_FILE%,%N_SDI_GUID%
bcdedit /set %N_WIM_GUID% path \Windows\System32\winload.efi
bcdedit /set %N_WIM_GUID% osdevice ramdisk=%N_WIM_FILE%,%N_SDI_GUID%
bcdedit /set %N_WIM_GUID% systemroot \Windows
bcdedit /set %N_WIM_GUID% detecthal yes
bcdedit /set %N_WIM_GUID% winpe yes
bcdedit /displayorder %N_WIM_GUID% /addlast
bcdedit /enum
pause