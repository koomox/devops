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
NET FILE 1>NUL 2>NUL
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

::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
SET OSPP="%ProgramFiles%\Microsoft Office\Office16\ospp.vbs"
cscript %OSPP% /dstatus
rem == Active Office Professional Plus 2016 ==
cscript %OSPP% /unpkey:GVGXT
cscript %OSPP% /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99
rem == Active Visio 2016 ==
cscript %OSPP% /unpkey:BTDRB
cscript %OSPP% /inpkey:PD3PC-RHNGV-FXJ29-8JK7D-RJRJK
rem == Active Project 2016 ==
cscript %OSPP% /unpkey:92FK9
cscript %OSPP% /inpkey:YG9NW-3K39V-2T3HJ-93F3Q-G83KT
cscript %OSPP% /sethst:kms.digiboy.ir
cscript %OSPP% /act
cscript %OSPP% /dstatus
pause