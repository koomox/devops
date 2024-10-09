#!/bin/bash
# 利用 iptables 实现中继（中转/端口转发）加速
apt install dnsutils -y

add_iptables_rules() {
read -p "请输入服务器IP地址或域名: " DOMAIN_NAME
read -p "请输入端口号" public_port

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
}

del_iptables_rules() {
read -p "请输入端口号" public_port

source_port=${public_port}
dest_port=${public_port}

iptables -D INPUT -m state --state NEW -m tcp -p tcp --sport ${source_port} -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --sport ${source_port} -j ACCEPT

iptables -D OUTPUT -p tcp --dport ${dest_port} -j ACCEPT
iptables -D OUTPUT -p udp --dport ${dest_port} -j ACCEPT

iptables -D FORWARD -p tcp --sport ${source_port} -j ACCEPT
iptables -D FORWARD -p udp --sport ${source_port} -j ACCEPT
iptables -D FORWARD -p tcp --dport ${dest_port} -j ACCEPT
iptables -D FORWARD -p udp --dport ${dest_port} -j ACCEPT
}

# 查看NAT规则
view_nat_rules() {
iptables -t nat -vnL POSTROUTING
iptables -t nat -vnL PREROUTING
}

clear_nat_rules() {
iptables -t nat -F
}

# 打开防火墙转发功能
enable_nat_rules() {
echo "打开NAT路由转发"
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
}

# 开始菜单
start_menu() {
	clear
	echo "============================="
	echo "环境: 适用于 Debian 9.x"
	echo "Author: allen.w"
	echo "============================="
	echo "1. 查看 NAT 规则"
	echo "2. 清空 NAT 规则"
	echo "3. 添加 NAT 规则"
	echo "4. 删除 NAT 规则"
	echo "5. 打开NAT路由转发"
	echo "6. 退出脚本"
	echo 
	read -p "请输入数字: " num
	case "$num" in
		1)
			view_nat_rules
			;;
		2)
			clear_nat_rules
			;;
		3)
			add_iptables_rules
			;;
		4)
			del_iptables_rules
			;;
		5)
			enable_nat_rules
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

start_menu