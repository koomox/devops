#!/bin/bash
initialize_haproxy() {
\cp -f /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
cat > /etc/haproxy/haproxy.cfg << EOF
global
	ulimit-n 51200
defaults
	log     global
	mode    tcp
	option  dontlognull
	timeout connect 5000
	timeout client  50000
	timeout server  50000
EOF
}

add_haproxy_user() {
username=$1
domain_name=$2
public_port=$3

echo -e "frontend ss-in-${username}\n\tbind *:${public_port}\n\tdefault_backend ss-out-${username}\nbackend ss-out-${username}\n\tserver server1 ${domain_name}:${public_port} maxconn 20480" >> /etc/haproxy/haproxy.cfg

iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${public_port} -j ACCEPT
iptables -A OUTPUT -p tcp --sport ${public_port} -j ACCEPT
iptables -A OUTPUT -p tcp --dport ${public_port} -j ACCEPT
}

reset_haproxy() {
	systemctl stop haproxy
	systemctl start haproxy
}

initialize_haproxy
add_haproxy_user [名称] [目标IP] [端口]
reset_haproxy