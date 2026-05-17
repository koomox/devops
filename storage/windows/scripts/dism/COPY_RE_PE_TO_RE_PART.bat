@echo off
SET N_DRIVE=%~d0
SET N_PATH=%~dp0
SET D_DRIVE=R:
SET N_OS=10
SET N_OS_BITS=x64
rmdir /S /Q "%D_DRIVE%\Recovery"
mkdir "%D_DRIVE%\Recovery"
mkdir "%D_DRIVE%\Recovery\WindowsRE\"
mkdir "%D_DRIVE%\Recovery\WindowsPE\"
%N_DRIVE%
cd "%N_DRIVE%\RecoveryImage\Recovery\WindowsRE\%N_OS%\%N_OS_BITS%\"
xcopy boot.sdi "%D_DRIVE%\Recovery\WindowsRE\" /H /K /Y
xcopy winre.wim "%D_DRIVE%\Recovery\WindowsRE\" /H /K /Y
cd "%N_DRIVE%\RecoveryImage\Recovery\WindowsPE\%N_OS_BITS%\"
xcopy USBZL.SDI "%D_DRIVE%\Recovery\WindowsPE\" /H /K /Y
xcopy NT63PEX64.WIM "%D_DRIVE%\Recovery\WindowsPE\" /H /K /Y
pause