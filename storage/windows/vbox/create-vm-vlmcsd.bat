@echo on
SET VIRTUALMACHINE_NAME=KMSSrv
SET VIRTUAL_FLOPPY_FILE_VLMCSD=floppy144-2.vfd
SET VBoxManage="%PROGRAMFILES%\Oracle\VirtualBox\VBoxManage.exe"

%VBoxManage% createvm --name %VIRTUALMACHINE_NAME% --ostype Linux --register
%VBoxManage% modifyvm %VIRTUALMACHINE_NAME% --memory 32
%VBoxManage% modifyvm %VIRTUALMACHINE_NAME% --usb on --audio none
%VBoxManage% modifyvm %VIRTUALMACHINE_NAME% --nic1 hostonly --hostonlyadapter1 "VirtualBox Host-Only Ethernet Adapter" --nictype1 Am79C973 --cableconnected1 on
%VBoxManage% storagectl %VIRTUALMACHINE_NAME% --add floppy --name "Floppy Controller"
MD "%USERPROFILE%\VirtualBox VMs\%VIRTUALMACHINE_NAME%"
COPY %VIRTUAL_FLOPPY_FILE_VLMCSD% "%USERPROFILE%\VirtualBox VMs\%VIRTUALMACHINE_NAME%\%VIRTUAL_FLOPPY_FILE_VLMCSD%"
%VBoxManage% storageattach %VIRTUALMACHINE_NAME% --storagectl "Floppy Controller" --device 0 --port 0 --type fdd --medium "%USERPROFILE%\VirtualBox VMs\%VIRTUALMACHINE_NAME%\%VIRTUAL_FLOPPY_FILE_VLMCSD%"
COPY vbox-kms.bat "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\vbox-kms.bat" /Y
%VBoxManage% startvm %VIRTUALMACHINE_NAME%
pause