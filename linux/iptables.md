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
### 备份/恢复 iptables 规则             
备份         
```sh
iptables-save -t nat > /etc/iptables.rules
```
恢复        
```sh
iptables-restore < /etc/iptables.rules
```
### 透明网关                
```sh
iptables -t nat -N TSOCKS

iptables -t nat -A TSOCKS -d ${server_ip}/24 -j RETURN

iptables -t nat -A TSOCKS -d 119.29.29.29/24 -j RETURN
iptables -t nat -A TSOCKS -d 223.5.5.5/24 -j RETURN
iptables -t nat -A TSOCKS -d 114.114.114.114/24 -j RETURN
iptables -t nat -A TSOCKS -d 8.8.8.8/24 -j RETURN
iptables -t nat -A TSOCKS -d 8.8.4.4/24 -j RETURN
iptables -t nat -A TSOCKS -d 1.1.1.1/24 -j RETURN

iptables -t nat -A TSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A TSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A TSOCKS -d 100.64.0.0/10 -j RETURN
iptables -t nat -A TSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A TSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A TSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A TSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A TSOCKS -d 198.18.0.0/15 -j RETURN
iptables -t nat -A TSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A TSOCKS -d 240.0.0.0/4 -j RETURN

iptables -t nat -A TSOCKS -p tcp -j REDIRECT --to-ports ${local_port}
iptables -t nat -A TSOCKS -p udp --dport=53 -j RETURN

iptables -t nat -I PREROUTING --in-interface ${eth0} -p tcp -j TSOCKS
iptables -t nat -I PREROUTING --in-interface ${eth0} -p udp -j TSOCKS
```
udp 转发           
```sh
ip rule add fwmark 0x01/0x01 table 100
ip route add local 0.0.0.0/0 dev lo table 100
```
```sh
iptables -t nat -A TSOCKS -p udp -j TPROXY --on-port ${local_port} --tproxy-mark 0x01/0x01
```
```
# Generated by xtables-save v1.8.2 on Fri Mar 13 23:37:17 2020
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:TSOCKS - [0:0]
-A PREROUTING -i ${eth0} -p udp -j TSOCKS
-A PREROUTING -i ${eth0} -p tcp -j TSOCKS
-A TSOCKS -d ${server_ip}/24 -j RETURN
-A TSOCKS -d 119.29.29.0/24 -j RETURN
-A TSOCKS -d 223.5.5.0/24 -j RETURN
-A TSOCKS -d 114.114.114.0/24 -j RETURN
-A TSOCKS -d 8.8.8.0/24 -j RETURN
-A TSOCKS -d 1.1.1.0/24 -j RETURN
-A TSOCKS -d 0.0.0.0/8 -j RETURN
-A TSOCKS -d 10.0.0.0/8 -j RETURN
-A TSOCKS -d 100.64.0.0/10 -j RETURN
-A TSOCKS -d 127.0.0.0/8 -j RETURN
-A TSOCKS -d 169.254.0.0/16 -j RETURN
-A TSOCKS -d 172.16.0.0/12 -j RETURN
-A TSOCKS -d 192.168.0.0/16 -j RETURN
-A TSOCKS -d 198.18.0.0/15 -j RETURN
-A TSOCKS -d 224.0.0.0/4 -j RETURN
-A TSOCKS -d 240.0.0.0/4 -j RETURN
-A TSOCKS -p tcp -j REDIRECT --to-ports ${local_port}
-A TSOCKS -p udp -m udp --dport 53 -j RETURN
-A TSOCKS -p udp -j REDIRECT --to-ports ${local_port}
COMMIT
# Completed on Fri Mar 13 23:37:17 2020
```