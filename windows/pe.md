# PE                  
WinPE：创建 USB 可启动驱动器: [传送门](https://technet.microsoft.com/zh-cn/library/hh825109.aspx)             
WinPE 网络驱动程序：初始化和添加驱动程序: [传送门](https://technet.microsoft.com/zh-cn/library/hh824935.aspx)             
WinPE：装载和自定义: [传送门](https://technet.microsoft.com/zh-cn/library/hh824972.aspx)               
适用于 Windows 8 的 WinPE：Windows PE 5.0[传送门](https://technet.microsoft.com/zh-cn/library/hh825110.aspx)               

部署和映像工具环境: `"%ProgramData%\Microsoft\Windows\Start Menu\Programs\Windows Kits\Windows ADK"`                  
目录: `"%ProgramFiles(x86)%\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"`                          

由 Copype 创建目录结构并复制 Windows PE 文件到 `C:\winpe_amd64`
```bat
copype amd64 C:\winpe_amd64
```

将 Windows PE 安装到 U 盘，并指定驱动器号        
```bat
MakeWinPEMedia /UFD C:\winpe_amd64 F:
```       
清除 U 盘，然后重新安装 Windows PE。这可以帮助你删除额外的启动分区或其他启动软件。           
```bat
diskpart
  list disk
  select disk <disk number>
  clean
  create partition primary
  format quick fs=fat32 label="Windows PE"
  assign letter="F"
  exit

MakeWinPEMedia /UFD C:\winpe_amd64 F:
```                
从 DVD 启动 Windows PE。创建一个可以刻录到 DVD 的 ISO 文件            
```bat
MakeWinPEMedia /ISO C:\winpe_amd64 c:\winpe_amd64\winpe.iso
```
## 在 Windows PE 驱动器上存储 Windows 映像           
通常，不能在 Windows PE U 盘上存储或捕获 Windows 映像。         
大部分 U 盘仅支持单个驱动器分区。MakeWinPEMedia 命令将驱动器格式化为 FAT32，它支持启动基于 BIOS 和基于 UEFI 的 PC。该文件格式支持的最大文件大小仅为 4 GB。        
```bat
diskpart
  list disk
  select <disk number>
  clean
  rem === Create the Windows PE partition. ===
  create partition primary size=2000
  format quick fs=fat32 label="Windows PE"
  assign letter=P
  active
  rem === Create a data partition. ===
  create partition primary
  format fs=ntfs quick label="Other files"
  assign letter=O
  list vol
  exit

MakeWinPEMedia /UFD C:\WinPE_amd64 P:
```             
