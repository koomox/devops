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
SET S_PATH=%~dp0
::SET D_DISM=F:\RecoveryImage\PE_Tools\Windows_10_version_1607_Kits\Deployment_Tools\amd64\DISM
::SET D_BCDBOOT=F:\RecoveryImage\PE_Tools\Windows_10_version_1607_Kits\Deployment_Tools\amd64\BCDBoot
SET D_DISM=%windir%\DISM
SET D_BCDBOOT=%windir%\BCDBoot
SET S_IMAGEX=%windir%\DISM\imagex.exe
SET D_IMAGEX=%windir%\System32\imagex.exe

if exist %D_DISM% (
	echo %D_DISM% Folder already exists!
) else (
	md %D_DISM%
	xcopy %S_PATH%\DISM %D_DISM% /S /E /H /K /Y
	echo copy Folder to %D_DISM%!
)

if exist %D_BCDBOOT% (
	echo %D_BCDBOOT% Folder already exists!
) else (
	md %D_BCDBOOT%
	xcopy %S_PATH%\BCDBoot %D_BCDBOOT% /S /E /H /K /Y
	echo copy Folder to %D_BCDBOOT%!
)

if exist %D_IMAGEX% (
	echo %D_IMAGEX% File already exists!
) else (
	xcopy %S_IMAGEX% %windir%\System32\ /H /K /Y
	echo copy File %S_IMAGEX% to %D_IMAGEX%!
)
pause