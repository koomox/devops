# KMS         
### Windows           
删除 KMS 激活信息        
```bat
REG QUERY "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /V "BackupProductKeyDefault" > %USERPROFILE%\Desktop\KMS-KEY.txt

"%SystemRoot%\System32\slmgr.vbs" /upk
"%SystemRoot%\System32\slmgr.vbs" /ckms
"%SystemRoot%\System32\slmgr.vbs" /rearm
```
Windows 7 Enterprise            
```bat
::cd /d "SystemRoot%\System32" 
::slmgr.vbs /upk
::slmgr.vbs /ipk 33PXH-7Y6KF-2VJC9-XBBR8-HVTHH
slmgr.vbs /skms 127.0.0.1
slmgr.vbs /ato
slmgr /xpr
```
Windows Server 2008 R2 Enterprise         
```bat
::slmgr.vbs /upk
::slmgr.vbs /ipk 489J6-VHDMP-X63PK-3K798-CPX3Y
slmgr.vbs /skms 127.0.0.1
slmgr.vbs /ato
```
Windows 10 Enterprise 2019 LTSB         
```bat
::slmgr.vbs /upk
::slmgr.vbs /ipk PG7H6-7RNT3-R4MGR-HMJK2-J462D
slmgr.vbs /skms 127.0.0.1
slmgr.vbs /ato
```
Windows 10 Enterprise      
```bat
::slmgr.vbs /upk
::slmgr.vbs /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43
slmgr.vbs /skms 127.0.0.1
slmgr.vbs /ato
```
Windows Server 2016 Standard      
```bat
::slmgr.vbs /upk
::slmgr.vbs /ipk WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
slmgr.vbs /skms 127.0.0.1
slmgr.vbs /ato
```
### Office          
Office Professional Plus 2010 VL         
```bat
cd /d "%ProgramFiles%\Microsoft Office\Office16"
::cscript ospp.vbs /unpkey:2QC6P
::cscript ospp.vbs /inpkey:MKCGC-FBXRX-BMJX6-F3Q8C-2QC6P
cscript ospp.vbs /sethst:127.0.0.1
cscript ospp.vbs /act
cscript ospp.vbs /dstatus
```
Office Professional Plus 2016         
```bat
cd /d "%ProgramFiles%\Microsoft Office\Office16"
::cscript ospp.vbs /unpkey:WFG99
::cscript ospp.vbs /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99
cscript ospp.vbs /sethst:127.0.0.1
cscript ospp.vbs /act
cscript ospp.vbs /dstatus
```
### 微软官方GVLK密钥                      
微软官方GVLK密钥: [Link](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj612867%28v%3dws.11%29)          
##### Windows Server 2019          
| Operating system edition | KMS Client Setup Key |
| :----------------------- | :------------------- |
| Windows Server 2019 ARM64 | GRFBW-QNDC4-6QBHG-CCK3B-2PR88 |
| Windows Server 2019 Azure Core | FDNH6-VW9RW-BXPJ7-4XTYG-239TB |
| Windows Server 2019 Datacenter | WMDGN-G9PQG-XVVXX-R3X43-63DFG |
| Windows Server 2019 Essentials | WVDHN-86M7X-466P6-VHXV7-YY726 |
| Windows Server 2019 Standard | N69G4-B89J2-4G8F4-WWYCC-J464C |
| Windows Server 2019 Datacenter (Semi-Annual Channel v.1809) | 6NMRW-2C8FM-D24W7-TQWMY-CWH2D |
| Windows Server 2019 Standard (Semi-Annual Channel v.1809) | N2KJX-J94YW-TQVFB-DG9YT-724CC |
| Windows Server 2019 Standard [Preview] | MFY9F-XBN2F-TYFMP-CCV49-RMYVH |
| Windows Server 2019 Datacenter [Preview] | 6XBNX-4JQGW-QX6QG-74P76-72V67 |
##### Windows Server 2016          
| Operating system edition | KMS Client Setup Key |
| :----------------------- | :------------------- |
| Windows Server 2016 Datacenter | CB7KF-BWN84-R7R2Y-793K2-8XDDG |
| Windows Server 2016 Standard | WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY |
| Windows Server 2016 Essentials | JCKRF-N37P4-C2D82-9YXRT-4M63B |
| Windows Server 2016 Azure Core | VP34G-4NPPG-79JTQ-864T4-R3MQX |
| Windows Server 2016 Cloud Storage | QN4C6-GBJD2-FB422-GHWJK-GJG2R |
| Windows Server 2016 ARM64 | K9FYF-G6NCK-73M32-XMVPY-F9DRR |
| Windows Server 2016 Datacenter (Semi-Annual Channel v.1803) | 2HXDN-KRXHB-GPYC7-YCKFJ-7FVDG |
| Windows Server 2016 Standard (Semi-Annual Channel v.1803) | PTXN8-JFHJM-4WC78-MPCBR-9W4KR |
| Windows Server 2016 Datacenter [Preview] | VRDD2-NVGDP-K7QG8-69BR4-TVFHB |
##### Windows 10           
| Operating system edition | KMS Client Setup Key |
| :----------------------- | :------------------- |
| Windows 10 Enterprise LTSC 2019 | M7XTQ-FN8P6-TTKYV-9D4CC-J462D |
| Windows 10 Enterprise LTSC 2019 N | 92NFX-8DJQP-P6BBQ-THF9C-7CG2H |
| Windows 10 Enterprise G | YYVX9-NTFWV-6MDM3-9PT4T-4M68B |
| Windows 10 Enterprise G N | 44RPN-FTY23-9VTTB-MP9BX-T84FV |
| Windows 10 Enterprise 2016 LTSB | DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ |
| Windows 10 Enterprise 2016 LTSB N | QFFDN-GRT3P-VKWWX-X7T3R-8B639 |
| Windows 10 Enterprise | NPPR9-FWDCX-D2C8J-H872K-2YT43 |
| Windows 10 Enterprise [Preview] | QNMXX-GCD3W-TCCT4-872RV-G6P4J |
| Windows 10 Enterprise S | H76BG-QBNM7-73XY9-V6W2T-684BJ |
| Windows 10 Enterprise 2015 LTSB | WNMTR-4C88C-JK8YV-HQ7T2-76DF9 |
| Windows 10 Enterprise 2015 LTSB N | 2F77B-TNFGY-69QQF-B8YKP-D69TJ |
| Windows 10 Enterprise N | DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4 |
| Windows 10 Enterprise S N | X4R4B-NV6WD-PKTVK-F98BH-4C2J8 |
| Windows 10 Enterprise for Virtual Desktops | CPWHC-NT2C7-VYW78-DHDB2-PG3GK |
| Windows 10 Home / Core | TX9XD-98N7V-6WMQ6-BX7FG-H8Q99 |
| Windows 10 Home / Core Country Specific | PVMJN-6DFY6-9CCP6-7BKTT-D3WVR |
| Windows 10 Home / Core N | 3KHY7-WNT83-DGQKR-F7HPR-844BM |
| Windows 10 Home / Core Single Language | 7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH |
| Windows 10 Education | NW6C2-QMPVW-D7KKK-3GKT6-VCFB2 |
| Windows 10 Education N | 2WH4N-8QGBV-H22JP-CT43Q-MDWWJ |
| Windows 10 Professional | W269N-WFGWX-YVC9B-4J6C9-T83GX |
| Windows 10 Professional N | MH37W-N47XK-V7XM9-C7227-GCQG9 |
| Windows 10 Professional S [Pre-Release] | 3NF4D-GF9GY-63VKH-QRC3V-7QW8P |
| Windows 10 Professional S N [Pre-Release] | KNDJ3-GVHWT-3TV4V-36K8Y-PR4PF |
| Windows 10 Professional Student [Pre-Release] | YNXW3-HV3VB-Y83VG-KPBXM-6VH3Q |
| Windows 10 Professional Student N [Pre-Release] | 8G9XJ-GN6PJ-GW787-MVV7G-GMR99 |
| Windows 10 Professional Workstation | NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J |
| Windows 10 Professional Workstation N | 9FNHH-K3HBT-3W4TD-6383H-6XYWF |
| Windows 10 Professional Education | 6TP4R-GNPTD-KYYHQ-7B7DP-J447Y |
| Windows 10 Professional Education N | YVWGF-BXNMC-HTQYQ-CPQ99-66QFC |
| Windows 10 Professional [Preview] | XQHPH-N4D9W-M8P96-DPDFP-TMVPY |
| Windows 10 Professional WMC [Pre-Release] | NKPM6-TCVPT-3HRFX-Q4H9B-QJ34Y |
| Windows 10 Remote Server | 7NBT4-WGBQX-MP4H7-QXFF8-YP3KX |
| Windows 10 S (Lean) | NBTWJ-3DR69-3C4V8-C26MC-GQ9M6 |
| Windows 10 IoT Core [Pre-Release] | 7NX88-X6YM3-9Q3YT-CCGBF-KBVQF |
| Windows 10 Core Connected [Pre-Release] | DJMYQ-WN6HG-YJ2YX-82JDB-CWFCW |
| Windows 10 Core Connected N [Pre-Release] | JQNT7-W63G4-WX4QX-RD9M9-6CPKM |
| Windows 10 Core Connected Single Language [Pre-Release] | QQMNF-GPVQ6-BFXGG-GWRCX-7XKT7 |
| Windows 10 Core Connected Country Specific [Pre-Release] | FTNXM-J4RGP-MYQCV-RVM8R-TVH24 |
##### Windows Server 2012 R2 and Windows 8.1          
| Operating system edition | KMS Client Setup Key |
| :----------------------- | :------------------- |
| Windows 8.1 Professional | GCRJD-8NW9H-F2CDX-CCM8D-9D6T9 |
| Windows 8.1 Professional N | HMCNV-VVBFX-7HMBH-CTY9B-B4FXY |
| Windows 8.1 Enterprise | MHF9N-XY6XB-WVXMC-BTDCT-MKKG7 |
| Windows 8.1 Enterprise N | TT4HM-HN7YT-62K67-RGRQJ-JFFXW |
| Windows Server 2012 R2 Server Standard | D2N9P-3P6X9-2R39C-7RTCD-MDVJX |
| Windows Server 2012 R2 Datacenter | W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9 |
| Windows Server 2012 R2 Essentials | KNC87-3J2TX-XB4WP-VCPJV-M4FWM |
##### Windows Server 2012 and Windows 8           
| Operating system edition | KMS Client Setup Key |
| :----------------------- | :------------------- |
| Windows 8 Core / Server 2012 | BN3D2-R7TKB-3YPBD-8DRP2-27GG4 |
| Windows 8 Core / Server 2012 N | 8N2M2-HWPGY-7PGT9-HGDD8-GVGGY |
| Windows 8 Core / Server 2012 Country Specific | 4K36P-JN4VD-GDC6V-KDT89-DYFKP |
| Windows 8 Core / Server 2012 Single Language | 2WN2H-YGCQR-KFX6K-CD6TF-84YXQ |
| Windows Server 2012 Server Standard | XC9B7-NBPP2-83J2H-RHMBY-92BT4 |
| Windows Server 2012 MultiPoint Standard | HM7DN-YVMH3-46JC3-XYTG7-CYQJJ |
| Windows Server 2012 MultiPoint Premium | XNH6W-2V9GX-RGJ4K-Y8X6F-QGJ2G |
| Windows Server 2012 Datacenter | 48HP8-DN98B-MYWDG-T2DCC-8W83P |
| Windows 8 Professional WMC | GNBB8-YVD74-QJHX6-27H4K-8QHDG |
| Windows 8 Embedded Industry Professional | RYXVT-BNQG7-VD29F-DBMRY-HT73M |
| Windows 8 Embedded Industry Enterprise | NKB3R-R2F8T-3XCDP-7Q2KW-XWYQ2 |
| Windows 8 Enterprise | 32JNW-9KQ84-P47T8-D8GGY-CWCK7 |
| Windows 8 Enterprise N | JMNMF-RHW7P-DMY6X-RF3DR-X2BQT |
| Windows 8 Professional | NG4HW-VH26C-733KW-K6F98-J8CK4 |
| Windows 8 Professional N |  XCVCF-2NXM9-723PB-MHCB7-2RYQQ |
##### Windows 7 and Windows Server 2008 R2          
| Operating system edition | KMS Client Setup Key |
| :----------------------- | :------------------- |
| Windows 7 Enterprise | 33PXH-7Y6KF-2VJC9-XBBR8-HVTHH |
| Windows 7 Enterprise E | C29WB-22CC8-VJ326-GHFJW-H9DH4 |
| Windows 7 Enterprise N | YDRBP-3D83W-TY26F-D46B2-XCKRJ |
| Windows 7 Professional | FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4 |
| Windows 7 Professional E | W82YF-2Q76Y-63HXB-FGJG9-GF7QX |
| Windows 7 Professional N | MRPKT-YTG23-K7D7T-X2JMM-QY7MG |
| Windows 7 Embedded POSReady | YBYF6-BHCR3-JPKRB-CDW7B-F9BK4 |
| Windows 7 Embedded Standard | XGY72-BRBBT-FF8MH-2GG8H-W7KCW |
| Windows 7 ThinPC | 73KQT-CD9G6-K7TQG-66MRP-CQ22C |
| Windows Server 2008 R2 Web | 6TPJF-RBVHG-WBW2R-86QPH-6RTM4 |
| Windows Server 2008 R2 HPC edition | TT8MH-CG224-D3D7Q-498W2-9QCTX |
| Windows Server 2008 R2 Standard | YC6KT-GKW9T-YTKYR-T4X34-R7VHC |
| Windows Server 2008 R2 Enterprise | 489J6-VHDMP-X63PK-3K798-CPX3Y |
| Windows Server 2008 R2 Datacenter | 74YFP-3QFB3-KQT8W-PMXWJ-7M648 |
| Windows Server 2008 R2 for Itanium-based Systems | GT63C-RJFQ3-4GMB6-BRFB9-CB83V |
##### Windows Vista and Windows Server 2008             
| Operating system edition | KMS Client Setup Key |
| :----------------------- | :------------------- |
| Windows Vista Business | YFKBB-PQJJV-G996G-VWGXY-2V3X8 |
| Windows Vista Business N | HMBQG-8H2RH-C77VX-27R82-VMQBT |
| Windows Vista Enterprise | VKK3X-68KWM-X2YGT-QR4M6-4BWMV |
| Windows Vista Enterprise N | VTC42-BM838-43QHV-84HX6-XJXKV |
| Windows Web Server 2008 | WYR28-R7TFJ-3X2YQ-YCY4H-M249D |
| Windows Server 2008 Standard | TM24T-X9RMF-VWXK6-X8JC9-BFGM2 |
| Windows Server 2008 Standard without Hyper-V | W7VD6-7JFBR-RX26B-YKQ3Y-6FFFJ |
| Windows Server 2008 Enterprise | YQGMW-MPWTJ-34KDK-48M3W-X4Q6V |
| Windows Server 2008 Enterprise without Hyper-V | 39BXF-X8Q23-P2WWT-38T2F-G3FPG |
| Windows Server 2008 HPC | RCTX3-KWVHP-BR6TB-RB6DM-6X7HP |
| Windows Server 2008 Datacenter | 7M67G-PC374-GR742-YH8V4-TCBY3 |
| Windows Server 2008 Datacenter without Hyper-V | 22XQ2-VRXRG-P8D42-K34TD-G3QQC |
| Windows Server 2008 for Itanium-Based Systems | 4DWFP-JF3DJ-B7DTH-78FJB-PDRHK |
##### Office 2010         
| Operating system edition | KMS Client Setup Key |
| :----------------------- | :------------------- |
| Office Access 2010 | V7Y44-9T38C-R2VJK-666HK-T7DDX |
| Office Excel 2010 | H62QG-HXVKF-PP4HP-66KMR-CW9BM |
| Office Groove (SharePoint Workspace) 2010 | QYYW6-QP4CB-MBV6G-HYMCJ-4T3J4 |
| Office InfoPath 2010 | K96W8-67RPQ-62T9Y-J8FQJ-BT37T |
| Office Mondo 1 2010 | YBJTT-JG6MD-V9Q7P-DBKXJ-38W9R |
| Office Mondo 2 2010 | 7TC2V-WXF6P-TD7RT-BQRXR-B8K32 |
| Office OneNote 2010 | Q4Y4M-RHWJM-PY37F-MTKWH-D3XHX |
| Office OutLook 2010 | 7YDC2-CWM8M-RRTJC-8MDVC-X3DWQ |
| Office PowerPoint 2010 | RC8FX-88JRY-3PF7C-X8P67-P4VTT |
| Office Professional Plus 2010 | VYBBJ-TRJPB-QFQRF-QFT4D-H3GVB |
| Office Project Professional 2010 | YGX6F-PGV49-PGW3J-9BTGG-VHKC6 |
| Office Project Standard 2010 | 4HP3K-88W3F-W2K3D-6677X-F9PGB |
| Office Publisher 2010 | BFK7F-9MYHM-V68C7-DRQ66-83YTP |
| Office Small Business Basics 2010 | D6QFG-VBYP2-XQHM7-J97RH-VVRCK |
| Office Standard 2010 | V7QKV-4XVVR-XYV4D-F7DFM-8R6BM |
| Office Visio Premium 2010 | D9DWC-HPYVV-JGF4P-BTWQB-WX8BJ |
| Office Visio Professional 2010 | 7MCW8-VRQVK-G677T-PDJCM-Q8TCP |
| Office Visio Standard 2010 | 767HD-QGMWX-8QTDB-9G3R2-KHFGJ |
| Office Word 2010 | HVHB3-C6FV7-KQX9W-YQG79-CRY7T |
| Office Starter 2010 Retail | VXHHB-W7HBD-7M342-RJ7P8-CHBD6 |
| Office SharePoint Designer (Frontpage) 2010 Retail | H48K6-FB4Y6-P83GH-9J7XG-HDKKX |