#!/bin/bash
read -p "请输入 SSH 端口: " SSH_PORT
cat > /etc/iptables.rules << EOF
# Generated by iptables-save v1.6.0 on Sat Apr 27 08:31:29 2019
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport ${SSH_PORT} -j ACCEPT
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
COMMIT
# Completed on Sat Apr 27 08:31:29 2019
EOF

cat /etc/iptables.rules