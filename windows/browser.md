# Browser              
### Google Chrome        
Google Chrome chinese 64bit: [Download](https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B754CC110-B9C8-798B-4231-9054058921FC%7D%26lang%3Dzh-CN%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup64.exe)          
Google Chrome chinese 32bit: [Download](https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B754CC110-B9C8-798B-4231-9054058921FC%7D%26lang%3Dzh-CN%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx86-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup.exe)          

Google Chrome english 64bit: [Download](https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B754CC110-B9C8-798B-4231-9054058921FC%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup64.exe)           
Google Chrome english 32bit: [Download](https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B754CC110-B9C8-798B-4231-9054058921FC%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx86-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup.exe)           

Google Chrome MAC OS X: [Download](https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg)             
### Google Chrome 109.0.5414.120 WIN7 final version              
Google Chrome 109.0.5414.120 WIN7 final version 64bit： [Download](https://dl.google.com/release2/chrome/czao2hrvpk5wgqrkz4kks5r734_109.0.5414.120/109.0.5414.120_chrome_installer.exe)           
Google Chrome 109.0.5414.120 WIN7 final version 32bit： [Download](https://dl.google.com/release2/chrome/acihtkcueyye3ymoj2afvv7ulzxa_109.0.5414.120/109.0.5414.120_chrome_installer.exe)        

### Google Chrome 49.0.2623.112 XP final version            
Google Chrome 49.0.2623.112 XP final version 64bit： [Download](http://dl.google.com/release2/va5qxmf7d3oalefqdjoubnamxboyf9zt3o6zj33pzo2r3adq2cjea9an8hhc6tje8y4jiieqsruld9oyajv9i6atj40utl3hpl2/49.0.2623.112_chrome_installer_win64.exe)           
Google Chrome 49.0.2623.112 XP final version 32bit： [Download](http://dl.google.com/release2/h8vnfiy7pvn3lxy9ehfsaxlrnnukgff8jnodrp0y21vrlem4x71lor5zzkliyh8fv3sryayu5uk5zi20ep7dwfnwr143dzxqijv/49.0.2623.112_chrome_installer.exe)                  
### Firefox         
Firefox 64bit: [Download](https://download-installer.cdn.mozilla.net/pub/firefox/releases/126.0/win64/zh-CN/Firefox%20Setup%20126.0.exe)       
Firefox 32bit: [Download](https://download-installer.cdn.mozilla.net/pub/firefox/releases/126.0/win32/zh-CN/Firefox%20Setup%20126.0.exe)       
### Firefox 52.0.2 XP final version          
Firefox 52.0.2 XP final version 64bit： [Download](https://ftp.mozilla.org/pub/firefox/releases/52.0.2/win64/zh-CN/Firefox%20Setup%2052.0.2.exe)         
Firefox 52.0.2 XP final version 32bit： [Download](https://ftp.mozilla.org/pub/firefox/releases/52.0.2/win32/zh-CN/Firefox%20Setup%2052.0.2.exe)         
### Firefox Developer Edition           
Firefox Developer Edition 64bit: [Download](https://download-installer.cdn.mozilla.net/pub/devedition/releases/127.0b3/win64/zh-CN/Firefox%20Setup%20127.0b3.exe)          
Firefox Developer Edition 32bit: [Download](https://download-installer.cdn.mozilla.net/pub/devedition/releases/127.0b3/win32/zh-CN/Firefox%20Setup%20127.0b3.exe)          
### Download script           
[source](/storage/linux/scripts/browser.sh)           
```sh
wget -O browser.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/browser.sh
chmod +x ./browser.sh
./browser.sh
```
### 用法           
Chrome 浏览器缓存目录 `%userprofile%\AppData\Local\Google`                
Firefox 多用户配置 `about:profiles`          
Chrome enable DNS-over-HTTPS `chrome://flags/#dns-over-https`         
### Firefox 配置文件           
`%USERPROFILE%\AppData\Roaming\Mozilla\Firefox\` 用户配置文件目录, 主要存储与用户相关的配置信息和设置                         
`%USERPROFILE%\AppData\Local\Mozilla\Firefox\Profiles` 具体配置文件存储目录,每个用户配置文件会在这里有一个子文件夹          
### 硬件加速           
Disable Hardware Acceleration in Chrome Using the Registry        
Create file `HardwareAccelerationModeEnabled.reg`       
```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome]
"HardwareAccelerationModeEnabled"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"HardwareAccelerationModeEnabled"=dword:00000000
```