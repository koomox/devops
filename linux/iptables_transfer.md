# iptables 中转服务器              
单端口，端口转发            
```
iptables -t nat -A PREROUTING -p tcp --dport [本地端口] -j DNAT --to-destination [目标IP:目标端口]
iptables -t nat -A PREROUTING -p udp --dport [本地端口] -j DNAT --to-destination [目标IP:目标端口]
iptables -t nat -A POSTROUTING -p tcp -d [目标IP] --dport [目标端口] -j SNAT --to-source [本地服务器主网卡绑定IP]
iptables -t nat -A POSTROUTING -p udp -d [目标IP] --dport [目标端口] -j SNAT --to-source [本地服务器主网卡绑定IP]
```
多端口，端口转发              
```
iptables -t nat -A PREROUTING -p tcp -m tcp --dport 10000:30000 -j DNAT --to-destination 1.1.1.1:10000-30000
iptables -t nat -A PREROUTING -p udp -m udp --dport 10000:30000 -j DNAT --to-destination 1.1.1.1:10000-30000
iptables -t nat -A POSTROUTING -d 1.1.1.1 -p tcp -m tcp --dport 10000:30000 -j SNAT --to-source 2.2.2.2
iptables -t nat -A POSTROUTING -d 1.1.1.1 -p udp -m udp --dport 10000:30000 -j SNAT --to-source 2.2.2.2
```

利用 iptables 实现中继（中转/端口转发），单端口完整版，支持TCP、UDP 协议。      
```
iptables -t nat -A PREROUTING -p tcp --dport [本地端口] -j DNAT --to-destination [目标IP:目标端口]
iptables -t nat -A PREROUTING -p udp --dport [本地端口] -j DNAT --to-destination [目标IP:目标端口]
iptables -t nat -A POSTROUTING -p tcp -d [目标IP] --dport [目标端口] -j SNAT --to-source [本地服务器主网卡绑定IP]
iptables -t nat -A POSTROUTING -p udp -d [目标IP] --dport [目标端口] -j SNAT --to-source [本地服务器主网卡绑定IP]

iptables -A INPUT -m state --state NEW -m tcp -p tcp --sport [本地端口] -j ACCEPT
iptables -A INPUT -m state --state NEW -m udp -p udp --sport [本地端口] -j ACCEPT

iptables -A OUTPUT -p tcp --dport [目标端口] -j ACCEPT
iptables -A OUTPUT -p udp --dport [目标端口] -j ACCEPT

iptables -A FORWARD -p tcp --sport [本地端口] -j ACCEPT
iptables -A FORWARD -p udp --sport [本地端口] -j ACCEPT
iptables -A FORWARD -p tcp --dport [目标端口] -j ACCEPT
iptables -A FORWARD -p udp --dport [目标端口] -j ACCEPT
```
查看NAT规则            
```sh
iptables -t nat -vnL POSTROUTING
iptables -t nat -vnL PREROUTING
```
### 一键添加 iptables 中转服务        
版本1，一次只能添加一个 NAT 规则              
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/iptables/iptables_transfer_v1.sh
chmod +x ./iptables_transfer_v1.sh
./iptables_transfer_v1.sh
```
版本2， 可添加、删除、查看、清空 NAT 规则表             
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/iptables/iptables_transfer_v2.sh
chmod +x ./iptables_transfer_v2.sh
./iptables_transfer_v2.sh
```