# iptables             
删除所有 iptables 规则，自定义规则链           
```sh
#!/bin/bash
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
```
### 透明网关                
```sh
iptables -t nat -N SHADOWSOCKS
iptables -t nat -A SHADOWSOCKS -p tcp --dport ${server_port} -j RETURN

iptables -t nat -A SHADOWSOCKS -d ${server_ip} -j RETURN
iptables -t nat -A SHADOWSOCKS -d 0.0.0.0 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 127.0.0.1 -j RETURN

iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports ${local_port}
iptables -t nat -I PREROUTING -p tcp -j SHADOWSOCKS
```
