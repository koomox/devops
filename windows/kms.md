# KMS         
### Windows           
Windows 7 Enterprise            
```bat
slmgr.vbs /upk
slmgr.vbs /ipk 33PXH-7Y6KF-2VJC9-XBBR8-HVTHH
slmgr.vbs /skms 127.0.0.1
slmgr.vbs /ato
```
Windows Server 2008 R2 Enterprise         
```bat
slmgr.vbs /upk
slmgr.vbs /ipk 489J6-VHDMP-X63PK-3K798-CPX3Y
slmgr.vbs /skms 127.0.0.1
slmgr.vbs /ato
```
Windows 10 Enterprise 2016 LTSB         
```bat
slmgr.vbs /upk
slmgr.vbs /ipk DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ
slmgr.vbs /skms 127.0.0.1
slmgr.vbs /ato
```
Windows 10 Enterprise      
```bat
slmgr.vbs /upk
slmgr.vbs /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43
slmgr.vbs /skms 127.0.0.1
slmgr.vbs /ato
```
Windows Server 2016 Standard      
```bat
slmgr.vbs /upk
slmgr.vbs /ipk WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
slmgr.vbs /skms 127.0.0.1
slmgr.vbs /ato
```
### Office          
Office Professional Plus 2010 VL         
```bat
SET OSPP="%ProgramFiles%\Microsoft Office\Office16\ospp.vbs"
::cscript %OSPP% /unpkey:2QC6P
::cscript %OSPP% /inpkey:MKCGC-FBXRX-BMJX6-F3Q8C-2QC6P
cscript %OSPP% /sethst:127.0.0.1
cscript %OSPP% /act
cscript %OSPP% /dstatus
```
Office Professional Plus 2016         
```bat
SET OSPP="%ProgramFiles%\Microsoft Office\Office16\ospp.vbs"
::cscript %OSPP% /unpkey:WFG99
::cscript %OSPP% /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99
cscript %OSPP% /sethst:127.0.0.1
cscript %OSPP% /act
cscript %OSPP% /dstatus
```

