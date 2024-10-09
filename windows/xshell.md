# Xshell        
### Xshell 5                    
Xshell 5: [传送门](http://www.netsarang.com/download/down_form.html?code=522&downloadType=0&licenseType=1)                
配置文件路径: `%userprofile%\Documents\NetSarang\`                        
备份 Xshell 5 ，只需要备份 `%userprofile%\Documents\NetSarang\Xshell\Sessions\` 和 `%userprofile%\Documents\NetSarang\SECSH\` 两个文件夹就可以了。                   
### Xshell 6           
Xshell 6: [传送门](https://www.netsarang.com/en/free-for-home-school/)         
Xshell-6.0.0184p [Download Link](https://cdn.netsarang.net/0ada4521/Xshell-6.0.0184p.exe)          
Xftp-6.0.0178p [Download Link](https://cdn.netsarang.net/0ada4521/Xftp-6.0.0178p.exe)          
XshellPlus-6.0.0025 [Download Link](https://cdn.netsarang.net/0ada4521/XshellPlus-6.0.0025.exe)         
配置文件路径: `%userprofile%\Documents\NetSarang Computer\6\`             
备份 Xshell 6 ，备份如下4个文件夹就可以了。
```
%userprofile%\Documents\NetSarang Computer\6\Common\
%userprofile%\Documents\NetSarang Computer\6\SECSH\
%userprofile%\Documents\NetSarang Computer\6\Xshell\Sessions\
%userprofile%\Documents\NetSarang Computer\6\Xshell\ColorScheme Files\
```
删除 Xshell 注册表       
```bat
REG DELETE HKEY_CURRENT_USER\Software\NetSarang /f
REG DELETE HKEY_LOCAL_MACHINE\Software\NetSarang /f
```