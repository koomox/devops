@echo off
SET PE_SDI_GUID={}
SET PE_WIM_GUID={}
SET PE_SDI_PART=T:
SET PE_SDI_FILE=\BOOT\BOOT.sdi
SET PE_WIM_FILE=[T:]\BOOT\10PEx64.wim
SET PE_WIM_BOOT_NAME="Windows PE"

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