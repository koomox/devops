#!/bin/bash
read -p "请输入 SSH 端口: " SSH_PORT
cat > /etc/iptables.rules << EOF
# Generated by iptables-save v1.6.0 on Sat Apr 27 08:31:29 2019
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT DROP [0:0]
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport ${SSH_PORT} -j ACCEPT
-A INPUT -p udp -m udp --sport 53 -j ACCEPT
-A INPUT -p udp -m udp --sport 123 -j ACCEPT
-A INPUT -p tcp -m tcp --sport 16630 -j ACCEPT
-A OUTPUT -o lo -j ACCEPT
-A OUTPUT -p icmp -m icmp --icmp-type any -j ACCEPT
-A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -p tcp -m tcp --sport ${SSH_PORT} -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport ${SSH_PORT} -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 21 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 53 -j ACCEPT
-A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
-A OUTPUT -p udp -m udp --dport 123 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 1080 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 5222 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 5223 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 5228 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 5229 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 5230 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 8000 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 8080 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 8181 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 14000 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 16630 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 993 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 587 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 995 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 465 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 8888 -j ACCEPT
COMMIT
# Completed on Sat Apr 27 08:31:29 2019
EOF

cat /etc/iptables.rules