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
SET OSPP="%ProgramFiles%\Microsoft Office\Office16\OSPP.vbs"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\ProPlusVL_KMS_Client-ppd.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\ProPlusVL_KMS_Client-ul.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\ProPlusVL_KMS_Client-ul-oob.xrm-ms"

cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\ProjectProVL_KMS_Client-ppd.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\ProjectProVL_KMS_Client-ul.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\ProjectProVL_KMS_Client-ul-oob.xrm-ms"

cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\VisioProVL_KMS_Client-ppd.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\VisioProVL_KMS_Client-ul.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\VisioProVL_KMS_Client-ul-oob.xrm-ms"

cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\client-issuance-bridge-office.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\client-issuance-root.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\client-issuance-root-bridge-test.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\client-issuance-stil.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\client-issuance-ul.xrm-ms"
cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\client-issuance-ul-oob.xrm-ms"

cscript %OSPP% /inslic:"%ProgramFiles%\Microsoft Office\root\Licenses16\pkeyconfig-office.xrm-ms"
pause