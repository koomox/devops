# Windows Defender Antivirus in Windows 10             
### 命令         
禁用 Windows Defender        
```bat
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
```
启用 Windows Defender
```bat
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware
```
查看注册表键       
```bat
REG QUERY "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntispyware
```
### 注册表          
排除文件或目录            
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths
```
文件类型            
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\Extensions
```
进程名称           
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\Processes
```

### Windows PowerShell        
排除文件或目录，添加、删除命令                 
```bat
Add-MpPreference -ExclusionPath "<Full path of file>" -Force

Remove-MpPreference -ExclusionPath "<Full path of file>" -Force

Add-MpPreference -ExclusionPath "C:\Users\Administrator\Downloads" -Force
```
文件类型         
```bat
Add-MpPreference -ExclusionExtension "<File type extension>" -Force

Remove-MpPreference -ExclusionExtension "<File type extension>" -Force

Add-MpPreference -ExclusionExtension ".jpg" -Force
```
进程名           
```bat
Add-MpPreference -ExclusionProcess "<Process name>" -Force

Remove-MpPreference -ExclusionProcess "<Process name>" -Force

Add-MpPreference -ExclusionProcess "SecHealthUI.exe" -Force
```
