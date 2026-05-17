# Add or Remove Exclusions for Windows Defender Antivirus in Windows 10           
### 注册表         
添加文件或文件夹路径到注册表             
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths
```
添加文件类型到注册表          
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\Extensions
```
添加进程名称到注册表         
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\Processes
```

```bat
REG ADD "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "%USERPROFILE%\Documents" /t REG_DWORD /d 0 /f
```
### Windows PowerShell         
```bat
Add-MpPreference -ExclusionPath "<Full path of file>" -Force

Remove-MpPreference -ExclusionPath "<Full path of file>" -Force
```

```bat
Add-MpPreference -ExclusionExtension "<File type extension>" -Force

Remove-MpPreference -ExclusionExtension "<File type extension>" -Force
```

```bat
Add-MpPreference -ExclusionProcess "<Process name>" -Force

Remove-MpPreference -ExclusionProcess "<Process name>" -Force
```