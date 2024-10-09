# Proxifier 代理软件          
使用 Shadowsocks 代理，配置 SwitchyOmega 插件，只能实现 Chrome 浏览器科学上网，但是对于 WhatsApp、Line、Wire、Messenger、Facebook 等客户端，可以使用 Proxifier 实现应用程序的代理。         
Proxifier Portable Edition (Windows): [点击下载](https://www.proxifier.com/download/ProxifierPE.zip)            
Proxifier Portable Edition (macOS): [点击下载](https://www.proxifier.com/download/ProxifierMac.dmg)           
通用配置文件 (Windows): [Link](/storage/windows/Proxifier/Profiles/Default.ppx)           
一、首先我们设置 Shadowscks 本地代理类型 `socks5`，端口: `10258`。          
二、打开 Proxifier，添加代理服务器。          
![IMG_20190101_113900.png](/static/images/wiki/IMG_20190101_113900.png)                    
弹出下面的对话框，一定要点击“否”按钮，否则将默认代理服务器设置为全局代理。            
![IMG_20190101_113901.png](/static/images/wiki/IMG_20190101_113901.png)                    
三、设置代理规则，在 Applications 添加需要代理的应用程序。          
![IMG_20190101_113902.png](/static/images/wiki/IMG_20190101_113902.png)                    
四、将代理服务器地址 127.0.0.1 添加到 Localhost 规则的 Target hosts 中，否则将导致循环代理。（默认 127.0.0.1 已经中 Target hosts，一般用于代理服务器IP非本机IP的时候添加如：192.168.0.*）      
![IMG_20190101_113903.png](/static/images/wiki/IMG_20190101_113903.png)                    
五、选择 “Resolve hostname through proxy” 通过代理服务器解析域名，防止DNS劫持和污染。         
![IMG_20190101_113905.png](/static/images/wiki/IMG_20190101_113905.png)                   