@echo off
SET RE_SDI_GUID={}
SET RE_WIM_GUID={}
SET RE_SDI_PART=T:
SET RE_SDI_FILE=\RecoveryImage\RE\boot.sdi
SET RE_WIM_FILE=[T:]\RecoveryImage\RE\Winre.wim
SET RE_WIM_BOOT_NAME="Windows RE"

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /create /d %RE_WIM_BOOT_NAME% /device') DO @SET RE_SDI_GUID={%%I}
bcdedit /set %RE_SDI_GUID% ramdisksdidevice partition=%RE_SDI_PART%
bcdedit /set %RE_SDI_GUID% ramdisksdipath %RE_SDI_FILE%

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /create /d %RE_WIM_BOOT_NAME% /application osloader') DO @SET RE_WIM_GUID={%%I}
bcdedit /set %RE_WIM_GUID% device ramdisk=%RE_WIM_FILE%,%RE_SDI_GUID%
bcdedit /set %RE_WIM_GUID% path \Windows\System32\boot\winload.efi
bcdedit /set %RE_WIM_GUID% osdevice ramdisk=%RE_WIM_FILE%,%RE_SDI_GUID%
bcdedit /set %RE_WIM_GUID% systemroot \Windows
bcdedit /set %RE_WIM_GUID% detecthal yes
bcdedit /set %RE_WIM_GUID% winpe yes
bcdedit /displayorder %RE_WIM_GUID% /addlast
bcdedit /enum %RE_WIM_GUID%