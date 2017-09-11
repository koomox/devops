@echo off
SET N_DRIVE=%~d0
SET N_PATH=%~dp0

::SET N_BCDBOOT="F:\RecoveryImage\PE_Tools\Windows_10_version_1607_Kits\Deployment_Tools\amd64\BCDBoot\bcdboot.exe"
::SET N_BCDBOOT="%windir%\BCDBoot\bcdboot.exe"
::cd "%windir%\BCDBoot"

::%N_BCDBOOT% C:\Windows /s U: /f UEFI /l zh-cn
::%N_BCDBOOT% C:\Windows /s C: /f ALL /l zh-cn

SET N_BOOT="C:\Windows"
SET N_EFI_PART=U:

::bcdboot 系统目录路径 /s EFI分区 /f 启动方式 /l 语言
bcdboot C:\Windows /s U: /f UEFI /l zh-cn
bcdboot C:\Windows /s C: /f ALL /l zh-cn
pause