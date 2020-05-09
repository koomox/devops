@echo off
SET VIRTUALMACHINE_NAME=KMSSrv
SET VBoxManage="%PROGRAMFILES%\Oracle\VirtualBox\VBoxManage.exe"
%VBoxManage% startvm %VIRTUALMACHINE_NAME% -type headless