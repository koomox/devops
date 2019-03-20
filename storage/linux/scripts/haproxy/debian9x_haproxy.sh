#!/bin/bash

# 安装 HaProxy
function install_haproxy() {
	apt install haproxy -y
}

function initialize_haproxy() {
	if [ ! -f /etc/haproxy/haproxy.cfg.bak ]; then
		\cp -f /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
	fi
	echo -e "global\n\tulimit-n 51200\ndefaults\n\tlog global\n\tmode tcp\n\toption dontlognull\n\ttimeout connect 5000\n\ttimeout client 50000\n\ttimeout server 50000" > /etc/haproxy/haproxy.cfg
}

function add_haproxy_user() {
	read -p "请输入用户名: " username
	read -p "请输入目标服务器域名或IP地址: " domain_name
	read -p "请输入端口号: " public_port

	echo -e "frontend ss-in-${username}\n\tbind *:${public_port}\n\tdefault_backend ss-out-${username}\nbackend ss-out-${username}\n\tserver server1 ${domain_name}:${public_port} maxconn 32" >> /etc/haproxy/haproxy.cfg

	iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${public_port} -j ACCEPT
	iptables -A OUTPUT -p tcp --sport ${public_port} -j ACCEPT
	iptables -A OUTPUT -p tcp --dport ${public_port} -j ACCEPT
}

function del_haproxy_rules() {
	read -p "请输入端口号: " public_port

	iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport ${public_port} -j ACCEPT
	iptables -D OUTPUT -p tcp --sport ${public_port} -j ACCEPT
	iptables -D OUTPUT -p tcp --dport ${public_port} -j ACCEPT
}

function reset_haproxy() {
	systemctl stop haproxy
	systemctl start haproxy
}

# 开始菜单
function start_menu() {
	clear
	echo "============================="
	echo "环境: 适用于 Debian 9.x"
	echo "Author: allen.w"
	echo "============================="
	echo "1. 安装 HaProxy"
	echo "2. 初始化 HaProxy"
	echo "3. 添加 HaProxy 规则"
	echo "4. 删除 HaProxy 规则"
	echo "5. 重置 HaProxy"
	echo "6. 退出脚本"
	echo 
	read -p "请输入数字: " num
	case "$num" in
		1)
			install_haproxy
			;;
		2)
			initialize_haproxy
			;;
		3)
			add_haproxy_user
			;;
		4)
			del_haproxy_rules
			;;
		5)
			reset_haproxy
			;;
		6)
			exit 1
			;;
		*)
			clear
			echo "请输入正确的数字"
			sleep 5s
			start_menu
			;;
	esac
}

while true
do
start_menu
done