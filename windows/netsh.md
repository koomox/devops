# netsh           
### firewall         
Create Firewall Rules using cmd          
Syntax       
```
netsh advfirewall firewall add rule name="RULENAME" dir=[in/out] action=[allow/block/bypass] protocol=[tcp/udp] localip=[any] remoteip=[any]
```
Block program (executable)         
```batch
netsh advfirewall firewall add rule name="BlockProgram" dir=out program="c:\temp\programtoblock.exe" profile=any action=block
```
Allow port      
```batch
netsh advfirewall firewall add rule name="HTTP" dir=in action=allow protocol=TCP localport=80
```