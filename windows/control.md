# 常用命令               
控制面板           
```
Control
rundll32.exe shell32.dll,Control_RunDLL
```
文件夹属性选项卡          
```
control.exe /name Microsoft.folderoptions
```
设备和打印机               
```
control Printers
control.exe /name Microsoft.AddHardware
control.exe /name Microsoft.Printers
```
程序和功能         
```
rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl
control.exe /name Microsoft.ProgramsAndFeatures
```
Internet 属性           
```
rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl
```
网络和共享中心          
```
control.exe /name Microsoft.NetworkAndSharingCenter
```
管理工具         
```
control.exe /name Microsoft.AdministrativeTools
```
设备管理器          
```
control.exe /name Microsoft.DeviceManager
```
字体        
```
control.exe /name Microsoft.Fonts
```
用户账户        
```
control.exe /name Microsoft.UserAccounts
```
Windows 防火墙          
```
control.exe /name Microsoft.WindowsFirewall
```
安全和维护 操作中心          
```
control.exe /name Microsoft.SecurityCenter
```
查看系统属性       
```
control.exe /name Microsoft.System
```

`compmgmt.msc` 计算机管理       
`devmgmt.msc` 设备管理器     
`diskmgmt.msc` 磁盘管理       
`certmgr.msc` 证书管理         
`gpedit.msc` 组策略       
`secpol.msc` 本地安全策略        
`services.msc` 本地服务设置       

`powercfg.cpl` 电源选项       
`osk` 屏幕键盘       
`calc` 计算器        
`charmap` 字符映射表        
`mspaint` 画图