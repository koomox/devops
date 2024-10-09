# Firefox          
### Firefox 浏览器         
Firefox 64 位: [点击下载](https://download-installer.cdn.mozilla.net/pub/firefox/releases/62.0/win64/zh-CN/Firefox%20Setup%2062.0.exe)       
Firefox 32 位: [点击下载](https://download-installer.cdn.mozilla.net/pub/firefox/releases/62.0/win32/zh-CN/Firefox%20Setup%2062.0.exe)       
### Firefox 52.0.2 XP 系统最终版          
Firefox 52.0.2 XP 系统最终版 64 位： [点击下载](https://ftp.mozilla.org/pub/firefox/releases/52.0.2/win64/zh-CN/Firefox%20Setup%2052.0.2.exe)         
Firefox 52.0.2 XP 系统最终版 32 位： [点击下载](https://ftp.mozilla.org/pub/firefox/releases/52.0.2/win32/zh-CN/Firefox%20Setup%2052.0.2.exe)         
### Firefox Developer Edition           
Firefox Developer Edition 64 位: [点击下载](https://download-installer.cdn.mozilla.net/pub/devedition/releases/63.0b5/win64/zh-CN/Firefox%20Setup%2063.0b5.exe)          
Firefox Developer Edition 32 位: [点击下载](https://download-installer.cdn.mozilla.net/pub/devedition/releases/63.0b5/win32/zh-CN/Firefox%20Setup%2063.0b5.exe)          
### 插件          
Extensions: `about:addons`       
Proxy SwitchyOmega: [在线安装](https://addons.mozilla.org/en-US/firefox/addon/switchyomega/)            

2019.5.4 遇到 firefox 扩展团灭的情况.          
已安装的附加组件被 Firefox 禁用，我该怎么办？            
如果一个未经签名的附加组件被禁用，您将不能继续使用它，并且附加组件管理器将显示信息： 未通过针对是否适用于 Firefox 的验证，现已被禁用。如果它提供已签名的版本，您可以在 Firefox 中移除此附加组件 ，然后通过 Mozilla 附加组件网站 重新安装它。           
如果没有提供经过签名的版本，请联系附加组件的开发者或作者，询问他们是否能提供签名后的更新版附加组件。您也可以提醒他们给附加组件签名。            
如何才能使用非签名的附加组件？（高级用户）Firefox的延长支持版（ESR）、开发者版和Nightly版，将允许通过把偏好 `xpinstall.signatures.required` 改为`false`来屏蔽增强的扩展签名要求，该偏好可通过 Firefox 配置编辑器（`about:config` 页）更改。            
如果要屏蔽语言包的签名要求，你需要将偏好`extensions.langpacks.signatures.required`设置为`false`。 还有其它一些山寨版的 Firefox 也允许此项屏蔽。更多内容，参阅 MozillaWiki 文章 附加组件/扩展签名。             

查看当前更新 `about:studies`             
### 多用户配置文件管理          
打开 Firefox 在地址栏输入 `about:profiles`，点击 `Create a New Profile`打开新建配置文件向导，创建完成后选择`Set as default profile`，重启浏览器 `Restart normally...`。       
Windows系统下，通过再快捷方式目标地址后面添加参数打开配置文件管理器。 可以使用 `-p`、`-p` 和 `-ProfileManager`，完整地址为 `"C:\Program Files\Mozilla Firefox\firefox.exe" -P`            
