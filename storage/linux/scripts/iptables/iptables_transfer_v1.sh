#!/bin/bash
# 利用 iptables 实现中继（中转/端口转发）加速
apt install dnsutils -y

read -p "请输入服务器IP地址或域名： " DOMAIN_NAME
read -p "请输入端口号: " public_port

local_ipaddr=$(ip addr | grep 'inet ' | grep -v '127.0.0.1' | grep -v '10.0.0.' | cut -d '/' -f1 | awk '{ print $2 }')
domain_ipaddr=$(dig ${DOMAIN_NAME} | grep "${DOMAIN_NAME}" | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")
source_port=${public_port}
dest_port=${public_port}
dest_ipaddr=${domain_ipaddr}

iptables -t nat -A PREROUTING -p tcp --dport ${source_port} -j DNAT --to-destination ${dest_ipaddr}:${dest_port}
iptables -t nat -A PREROUTING -p udp --dport ${source_port} -j DNAT --to-destination ${dest_ipaddr}:${dest_port}
iptables -t nat -A POSTROUTING -p tcp -d ${dest_ipaddr} --dport ${dest_port} -j SNAT --to-source ${local_ipaddr}
iptables -t nat -A POSTROUTING -p udp -d ${dest_ipaddr} --dport ${dest_port} -j SNAT --to-source ${local_ipaddr}

iptables -A INPUT -m state --state NEW -m tcp -p tcp --sport ${source_port} -j ACCEPT
iptables -A INPUT -m state --state NEW -m udp -p udp --sport ${source_port} -j ACCEPT

iptables -A OUTPUT -p tcp --dport ${dest_port} -j ACCEPT
iptables -A OUTPUT -p udp --dport ${dest_port} -j ACCEPT

iptables -A FORWARD -p tcp --sport ${source_port} -j ACCEPT
iptables -A FORWARD -p udp --sport ${source_port} -j ACCEPT
iptables -A FORWARD -p tcp --dport ${dest_port} -j ACCEPT
iptables -A FORWARD -p udp --dport ${dest_port} -j ACCEPT

# 查看NAT规则
iptables -t nat -vnL POSTROUTING
iptables -t nat -vnL PREROUTING