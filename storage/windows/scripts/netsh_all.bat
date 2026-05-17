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
:starting
ECHO 1. show ip address
ECHO 2. show dns
ECHO 3. reset TCP/IP
ECHO 4. reset WINSOCK
ECHO 5. DELET DNS BUFFER
ECHO 6. Exit

SET /P INPUT=Input Number: 
goto %INPUT%

:1
if %INPUT% == 1 (netsh interface ip show address)
goto starting

:2
if %INPUT% == 2 (netsh interface ip show dns)
goto starting

:3
if %INPUT% == 3 (netsh int ip reset)
goto starting

:4
if %INPUT% == 4 (netsh winsock reset)
goto starting

:5
if %INPUT% == 5 (ipconfig /flushdns)
goto starting

:6
exit