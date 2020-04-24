::::::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights V2
::::::::::::::::::::::::::::::::::::::::::::
REM Admin shell on windows is required for symlink support. Run the box normally with vagrant up if you don't require this behaviour.


@echo off
CLS
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================

:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
::NET FILE 1>NUL 2>NUL
>nul 2>&1 "%windir%\system32\cacls.exe" "%windir%\system32\config\system"
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

Title Running Admin shell
::::::::::::::::::::::::::::
:: START
::::::::::::::::::::::::::::

:Loading
ECHO ======================================
ECHO 1. Start Wireless Hotspot
ECHO 2. Stop Wireless Hotspot
ECHO 0. Close
SET /P INPUT=Input Number[0-2]: 

if %INPUT% == 1 (
	ECHO ------------------------------------
	ECHO [Hotspot]: Starting...
	goto START_WIRELESS
)
if %INPUT% == 2 (
	ECHO ------------------------------------
	ECHO [Hotspot]: Stoping...
	goto STOP_WIRELESS
)
goto closeing

:START_WIRELESS
SET /P INPUT_SSID=Input Hotspot SSID Name:
SET /P INPUT_KEY=Input Hotspot SSID Password:
NETSH WLAN set hostednetwork mode=allow ssid=%INPUT_SSID% key=%INPUT_KEY%
netsh wlan start hostednetwork
netsh wlan show hostednetwork
goto Loading

:STOP_WIRELESS
netsh wlan stop hostednetwork
netsh wlan set hostednetwork mode=disallow
goto Loading

:closeing
exit