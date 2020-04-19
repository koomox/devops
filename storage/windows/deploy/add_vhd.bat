@echo off
SET VHD_GUID={}
SET VHD_BOOT_NAME="Windows 10 VHD"

FOR /F "tokens=2 delims={,}" %%I IN ('bcdedit /copy {current} /d %VHD_BOOT_NAME%') DO @SET VHD_GUID={%%I}
bcdedit /set %VHD_GUID% device vhd="[R:]\VHD\win10.vhd"
bcdedit /set %VHD_GUID% osdevice vhd="[R:]\VHD\win10.vhd"
bcdedit /set %VHD_GUID% detecthal Yes
bcdedit /displayorder %VHD_GUID% /addlast