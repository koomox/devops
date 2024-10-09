# BCDEdit 命令        
BCDEdit 命令行选项: [传送门](https://msdn.microsoft.com/zh-cn/library/windows/hardware/mt450468(v=vs.85).aspx)          
### 显示BCD 系统存储的项          
```
bcdedit /enum
bcdedit /enum /v
bcdedit /enum all
bcdedit /enum all /v
```
参数`v`详细模式，完整显示所有标识符。         
```
bcdedit /enum > %USERPROFILE%\Desktop\bcdedit_bootinfo.txt
bcdedit /enum /v > %USERPROFILE%\Desktop\bcdedit_bootinfo.txt
bcdedit /enum all /v > %USERPROFILE%\Desktop\bcdedit_bootinfo.txt
```
### 删除启动项         
从BCD 系统存储启动项中删除指定的GUID项，
```
bcdedit /delete {GUID} /cleanup
```
