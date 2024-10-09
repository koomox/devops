# Windows 10 系统优化          
禁用 `Connected User Experiences and Telemetry`，`Diagnostic Execution Service`，`Diagnostic Policy Service`，`Diagnostic Service Host`，`Diagnostic System Host` 服务。           
禁用 `HomeGroup Listener`，`HomeGroup Provider` 服务。          
禁用 `Windows Search` 服务。           
禁用 `Program CompatibilityAssistant Service` 程序兼容性助手服务。           
### Windows 10 关闭 Windows Defender         
`DisableAntiSpyware` 值0代表启用，1代表禁用。 [点击查看源文件](/storage/windows/10/close_w10defender.reg)         
```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender]
"DisableAntiSpyware"=dword:00000001
```
### Windows 10 用照片查看器打开图片           
[点击查看源文件](/storage/windows/10/open_win10images.reg)       
```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations]
".bmp"="PhotoViewer.FileAssoc.Tiff"
".jpg"="PhotoViewer.FileAssoc.Tiff"
".jpeg"="PhotoViewer.FileAssoc.Tiff"
".png"="PhotoViewer.FileAssoc.Tiff"
```