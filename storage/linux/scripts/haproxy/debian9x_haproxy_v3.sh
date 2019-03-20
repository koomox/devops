#!/bin/bash
function initialize_haproxy() {
	if [ ! -f /etc/haproxy/haproxy.cfg.bak ]; then
		\cp -f /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
	fi
	echo -e "global\n\tulimit-n 51200\ndefaults\n\tlog global\n\tmode tcp\n\toption dontlognull\n\ttimeout connect 5000\n\ttimeout client 50000\n\ttimeout server 50000" > /etc/haproxy/haproxy.cfg
}

function add_haproxy_user() {
	username=$1
	domain_name=$2
	source_port=$3
	dest_port=$3

	echo -e "frontend ss-in-${username}\n\tbind *:${source_port}\n\tdefault_backend ss-out-${username}\nbackend ss-out-${username}\n\tserver server1 ${domain_name}:${dest_port} maxconn 32" >> /etc/haproxy/haproxy.cfg

	iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${source_port} -j ACCEPT
	iptables -A OUTPUT -p tcp --sport ${source_port} -j ACCEPT
	iptables -A OUTPUT -p tcp --dport ${dest_port} -j ACCEPT
}

function reset_haproxy() {
	systemctl stop haproxy
	systemctl start haproxy
}

initialize_haproxy
add_haproxy_user [名称] [目标IP] [目标端口]
reset_haproxy