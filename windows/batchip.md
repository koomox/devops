# 批处理设置 IP 地址              
设置静态IP地址         
```
netsh interface ip set address name="本地连接" source=static addr=192.168.0.88 mask=255.255.255.0
netsh interface ip set address name="本地连接" gateway=192.168.0.1 gwmetric=auto
```
设置自动获取IP地址          
```
netsh interface ip set address name="本地连接" source=dhcp
```
设置静态DNS
```
netsh interface ip set dns name="本地连接" source=static addr=192.168.0.1 register=PRIMARY
netsh interface ip set dns name="本地连接" addr=8.8.8.8 index=2
```
设置自动获取DNS        
```
netsh interface ip set dns name="本地连接" source=dhcp
```

批处理设置IP地址和DNS          
```
@echo off

SET INTERFACE_NAME="本地连接"
SET IPADDR=192.168.0.88
SET MASK=255.255.255.0
SET GATEWAY=192.168.0.1
SET DNS=8.8.8.8

netsh interface ip set address name=%INTERFACE_NAME% source=static addr=%IPADDR% mask=%MASK%
netsh interface ip set address name=%INTERFACE_NAME% gateway=%GATEWAY% gwmetric=auto
netsh interface ip set dns name=%INTERFACE_NAME% source=static addr=%GATEWAY% register=PRIMARY
netsh interface ip set dns name=%INTERFACE_NAME% addr=%DNS% index=2

pause
```
自动获取IP和DNS           
```
@echo off
SET INTERFACE_NAME="本地连接"
netsh interface ip set address name=%INTERFACE_NAME% source=dhcp
netsh interface ip set dns name=%INTERFACE_NAME% source=dhcp
pause
```


