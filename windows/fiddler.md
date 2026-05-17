# Fiddler         
Fiddler Classic: [Link](https://www.telerik.com/download/fiddler)           
m3u8 download: [Link](https://github.com/nilaoda/N_m3u8DL-CLI)        

安装 Fiddler, `Tools` -> `Options`, 选择　HTTPS, 勾选下面得选项, 中途会安装证书。        
![IMG_20220415_050400.png](/static/images/wiki/IMG_20220415_050400.png)         

在这里插入脚本         
```js
var sToInsert = "<script src='https://cdn.jsdelivr.net/gh/Tencent/vConsole@3.8.1/dist/vconsole.min.js'></script><script>var vConsole = new VConsole();</script>"
oSession.utilDecodeResponse();
oSession.utilReplaceOnceInResponse('</head>',sToInsert + '</head>', 0);
```
![IMG_20220415_050401.png](/static/images/wiki/IMG_20220415_050401.png)   

点击绿色按钮，在红色框部位填入以下代码并点击OK.           
```js
vConsole.showTab("network");
```