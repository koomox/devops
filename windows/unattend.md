# Windows 无人值守安装           
### Windows 全自动无人值守安装         
自动分区、自动安装，把无人值守文件 `Autounattend.xml` 添加到光盘根目录即可。           
Windows 10 Enterprise LTSB 2016 x64（Index: 1）: [点击查看源文件](/storage/windows/10/ADK/ltsb2016/x64/Autounattend.xml)             
Windows 10 Enterprise 1803 x64（Index: 2）: [点击查看源文件](/storage/windows/10/ADK/version1803/x64/Autounattend.xml)             
Windows 7 ULTIMATE SP1 x64（Index: 4）: [点击查看源文件](/storage/windows/7/AIK/ULTIMATESP1/x64/Autounattend.xml)             
Windows 7 ULTIMATE SP1 x86（Index: 5）: [点击查看源文件](/storage/windows/7/AIK/ULTIMATESP1/x86/Autounattend.xml)             
Windows 7 Enterprise SP1 x64（Index: 1）: [点击查看源文件](/storage/windows/7/AIK/EnterpriseSP1/x64/Autounattend.xml)             
Windows 7 Enterprise SP1 x86（Index: 1）: [点击查看源文件](/storage/windows/7/AIK/EnterpriseSP1/x86/Autounattend.xml)             
Windows Server 2008 R2 SERVERENTERPRISE x86（Index: 3）         
Windows Server 2008 R2 SERVERDATACENTER x64（Index: 5）         
Windows Server 2012 R2 SERVERENTERPRISE x86（Index: 2）         
Windows Server 2012 R2 SERVERDATACENTER x64（Index: 4）         
Windows Server 2016 SERVERENTERPRISE x86（Index: 2）         
Windows Server 2016 SERVERENTERPRISE x64（Index: 4）         
### Windows 部署后无人值守             
使用 Windows PE 分区，从 wim 文件恢复系统后，把无人值守文件 `unattend.xml` 复制到 `\Windows\Panther` 目录下。           
Windows 7 ULTIMATE SP1 x64: [点击查看源文件](/storage/windows/7/AIK/ULTIMATESP1/x64/Unattend.xml)             
Windows 7 ULTIMATE SP1 x86: [点击查看源文件](/storage/windows/7/AIK/ULTIMATESP1/x86/Unattend.xml)             
Windows 7 Enterprise SP1 x64: [点击查看源文件](/storage/windows/7/AIK/EnterpriseSP1/x64/Unattend.xml)             
Windows 7 Enterprise SP1 x86: [点击查看源文件](/storage/windows/7/AIK/EnterpriseSP1/x86/Unattend.xml)         

### Windows XP、2003 无人值守安装          
下面的无人值守安装文件主要用于虚拟机的自动安装，现在用于实体机安装 XP、2003 的已经很少了。         
把无人值守文件 `WINNT.SIF` 复制到安装光盘的 `I386` 或 `AMD64` 目录下，与安装的系统位数有关，32位系统放入 `I386` 目录，64位系统放入 `AMD64` 目录下。          
Windows XP Professional with Service Pack 3: [点击查看源文件](/storage/windows/xp/sp3/WINNT.SIF)          
Windows Server 2003 R2, Enterprise x64 Edition with SP2: [点击查看源文件](/storage/windows/2003/EnterpriseR2/x64/WINNT.SIF)     
Windows Server 2003 R2, Enterprise x86 Edition with SP2: [点击查看源文件](/storage/windows/2003/EnterpriseR2/x86/WINNT.SIF)     
### Windows 下载地址           

Windows Server 2008 x86 英文版: [点击下载](http://download.microsoft.com/download/d/d/b/ddb17dc1-a879-44dd-bd11-c0991d292ad7/6001.18000.080118-1840_x86fre_Server_en-us-KRMSFRE_EN_DVD.iso)          
Windows Server 2008 x86 多国语言包: [点击下载](https://download.microsoft.com/download/6/2/0/6200e8d9-3942-4ee2-b6f7-8feccb0c6286/6001.18000.080118-1840_x86fre_Server_LP_2-KRMSLP2_DVD.img)         
Windows Server 2008 x64 英文版: [点击下载](http://download.microsoft.com/download/d/d/b/ddb17dc1-a879-44dd-bd11-c0991d292ad7/6001.18000.080118-1840_amd64fre_Server_en-us-KRMSXFRE_EN_DVD.iso)          
Windows Server 2008 x64 多国语言包: [点击下载](https://download.microsoft.com/download/6/2/0/6200e8d9-3942-4ee2-b6f7-8feccb0c6286/6001.18000.080118-1840_amd64fre_Server_LP_2-KRMSLPX2_DVD.img)        