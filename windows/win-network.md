# Windows 常见网络故障            
### 无法上网             
ping 命令无法查询 domain, 部分软件可正常使用，但是浏览器无法工作。                 
```bat
netsh winsock reset
```
执行上面得命令重置 TCP 协议栈，重启系统可修复大部分得网络问题。                 