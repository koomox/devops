#!/bin/bash

function socat_add_user() {
	user=$1
	ip=$2
	public_port=$3

	iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${public_port} -j ACCEPT
	iptables -A OUTPUT -p tcp --sport ${public_port} -j ACCEPT
	iptables -A OUTPUT -p tcp --dport ${public_port} -j ACCEPT

	nohup socat TCP4-LISTEN:${public_port},reuseaddr,fork TCP4:${ip}:${public_port} >> /var/log/socat.log 2>&1 &
	nohup socat UDP4-LISTEN:${public_port},reuseaddr,fork UDP4:${ip}:${public_port} >> /var/log/socat.log 2>&1 &
}

function socat_add_port() {
	ip=$1
	public_port=$2

	nohup socat TCP4-LISTEN:${public_port},reuseaddr,fork TCP4:${ip}:${public_port} >> /var/log/socat.log 2>&1 &
	nohup socat UDP4-LISTEN:${public_port},reuseaddr,fork UDP4:${ip}:${public_port} >> /var/log/socat.log 2>&1 &
}

function socat_add_port_rules() {
	user=$1
	ip=$2
	public_port=$3

	iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${public_port} -j ACCEPT
	iptables -A INPUT -p udp --dport ${public_port} -j ACCEPT
	iptables -A OUTPUT -p tcp --sport ${public_port} -j ACCEPT
	iptables -A OUTPUT -p tcp --dport ${public_port} -j ACCEPT
	iptables -A OUTPUT -p udp --sport ${public_port} -j ACCEPT
	iptables -A OUTPUT -p udp --dport ${public_port} -j ACCEPT

	nohup socat TCP4-LISTEN:${public_port},reuseaddr,fork TCP4:${ip}:${public_port} >> /var/log/socat.log 2>&1 &
	nohup socat UDP4-LISTEN:${public_port},reuseaddr,fork UDP4:${ip}:${public_port} >> /var/log/socat.log 2>&1 &
}