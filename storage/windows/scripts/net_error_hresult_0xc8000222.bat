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
SET S_FOLDER=SoftwareDistribution
SET S_FOLDER_TMP=SoftwareDistribution_TMP
SET state=''

ECHO 1. Fix .Net 4 Hresult 0xc8000222 Error
ECHO 2. Recovery %S_FOLDER% Folder
SET /P INPUT=Input Number: 

if %INPUT% == 1 (
	ECHO Start Fix .Net 4 Hresult 0xc8000222 Error.
	goto get_service_state
)
if %INPUT% ==2 (
	ECHO Start Recovery %S_FOLDER% Folder.
	goto recovery_folder
)
goto closeing

:ren_folder_name
IF EXIST %windir%\%S_FOLDER% (
	REN %windir%\%S_FOLDER% %S_FOLDER_TMP%
	ECHO change %windir%\%S_FOLDER% folder to %S_FOLDER_TMP%.
) else (
	ECHO %windir%\%S_FOLDER% Folder not found!
)
goto closeing

:recovery_folder
IF EXIST %windir%\%S_FOLDER_TMP% (
	REN %windir%\%S_FOLDER_TMP% %S_FOLDER%
	ECHO Recovery %windir%\%S_FOLDER_TMP% floder to %S_FOLDER%.
) else (
	ECHO %windir%\%S_FOLDER_TMP% Folder not found!
)
goto get_service_state

:get_service_state
for /f "tokens=4" %%i in (
	'sc query WuAuServ ^|find "STATE"'
) do (
	if %%i == RUNNING (goto 1)
	if %%i == STOPPED (goto 2)
)
goto closeing

:1
if %INPUT% == 1 (
	ECHO Windows Closing...
	net stop WuAuServ
	ECHO Windows Closed.
	goto ren_folder_name
) else (ECHO Windows Update Run...)
goto closeing

:2
if %INPUT% == 2 (
	ECHO Start Windows Update service...
	net start WuAuServ
	ECHO Windows Update Run...
) else (
	ECHO Windows Update Closed.
	goto ren_folder_name
)
goto closeing

:closeing
ECHO Repair Complete.
pause
exit