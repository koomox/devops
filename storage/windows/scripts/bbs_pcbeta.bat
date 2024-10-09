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
attrib -H -R -S %systemroot%\System32\drivers\etc\hosts
(echo 218.93.127.136 pcbeta.com) >> %systemroot%\System32\drivers\etc\hosts
(echo 218.93.127.136 bbs.pcbeta.com) >> %systemroot%\System32\drivers\etc\hosts
(echo 218.93.127.136 uc.pcbeta.com) >> %systemroot%\System32\drivers\etc\hosts
(echo 218.93.127.136 www.pcbeta.com) >> %systemroot%\System32\drivers\etc\hosts
(echo 218.93.127.136 cdn.pcbeta.css.inimc.com) >> %systemroot%\System32\drivers\etc\hosts
(echo 218.93.127.136 static.template.pcbeta.com) >> %systemroot%\System32\drivers\etc\hosts
(echo 218.93.127.136 i.pcbeta.com) >> %systemroot%\System32\drivers\etc\hosts
(echo 218.93.127.136 cdn.pcbeta.static.inimc.com) >> %systemroot%\System32\drivers\etc\hosts
attrib +H +R +S %systemroot%\System32\drivers\etc\hosts
ipconfig /flushdns
pause