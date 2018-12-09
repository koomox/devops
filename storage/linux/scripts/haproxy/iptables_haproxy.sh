#!/bin/bash
add_haproxy_iptables_rules() {
public_port=$1

iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${public_port} -j ACCEPT
iptables -A OUTPUT -p tcp --sport ${public_port} -j ACCEPT
iptables -A OUTPUT -p tcp --dport ${public_port} -j ACCEPT
echo "添加 iptables 规则"
iptables -nvL | grep ${public_port}
}

add_haproxy_iptables_rules ${public_port}
add_haproxy_iptables_rules ${public_port}
add_haproxy_iptables_rules ${public_port}
add_haproxy_iptables_rules ${public_port}
add_haproxy_iptables_rules ${public_port}
add_haproxy_iptables_rules ${public_port}
add_haproxy_iptables_rules ${public_port}