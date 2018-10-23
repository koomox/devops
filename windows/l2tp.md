# L2TP 错误汇总          
### Windows 10 链接 L2TP 提示链接中断             
[点击查看源文件](../storage/windows/scripts/l2tp/l2tp_abort.reg)             
```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\RasMan\Parameters]
"AllowL2TPWeakCrypto"=dword:00000001
"ProhibitIpSec"=dword:00000001

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\PolicyAgent]
"AssumeUDPEncapsulationContextOnSendRule"=dword:00000002
```