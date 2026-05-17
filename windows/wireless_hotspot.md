# Windows 10 启用 wifi 热点               
### 查看 Windows 10 是否支持 wifi 热点                 
使用如下命令检查系统是否支持 wifi 热点功能                 
```bat
NETSH WLAN show drivers
```
![](/static/images/wiki/IMG_20200424_063300.jpg)           
如果显示 `Hosted network supported: Yes`, 系统就支持 wifi 热点功能.              
### 创建一个 wifi 热点                     
创建一个 wifi 热点，`ssid` wifi 名称, `key` wifi 密码       
```bat
NETSH WLAN set hostednetwork mode=allow ssid=Your_SSID key=Your_Passphrase
```
![](/static/images/wiki/IMG_20200424_063301.jpg)            
修改 wifi 热点名称          
```bat
NETSH WLAN set hostednetwork ssid=Your_New_SSID
```
修改 wifi 热点密码        
```bat
NETSH WLAN set hostednetwork key=Your_New_Passphrase
```
### 启用 wifi 热点         
如下命令启用 wifi 热点      
```bat
netsh wlan start hostednetwork
```
![](/static/images/wiki/IMG_20200424_063302.jpg)        
查看 wifi 热点           
```bat
netsh wlan show hostednetwork
```
### 删除 wifi 热点         
停用 wifi 热点       
```bat
netsh wlan stop hostednetwork
```
![](/static/images/wiki/IMG_20200424_063303.jpg)        
删除 wifi 热点       
```bat
netsh wlan set hostednetwork mode=disallow
```
### 桥接网络         
打开网络连接，鼠标右键点击 网络连接 ，选择属性              
![](/static/images/wiki/IMG_20200424_063305.jpg)      
共享标签页，选择创建的 wifi 热点         
![](/static/images/wiki/IMG_20200424_063306.png)      
关闭桥接网络       
![](/static/images/wiki/IMG_20200424_063307.jpg)      
### 一键启用 wifi 热点          
一键启用/停用 wifi 热点        [source](/storage/windows/scripts/wireless_hotspot.bat)            