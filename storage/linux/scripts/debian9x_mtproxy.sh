#!/bin/bash
MTPROXY_PORT=443
MTPROXY_SECRET="*****"
MTPROXY_SERVICE="/etc/systemd/system/MTProxy.service"

installation_dependency(){
	if grep -Eqi "CentOS|Red Hat|RedHat" /etc/issue || grep -Eq "CentOS|Red Hat|RedHat" /etc/*-release || grep -Eqi "CentOS|Red Hat|RedHat" /proc/version; then
		release="CentOS"
	elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
		release="Debian"
	elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release || grep -Eqi "Fedora" /proc/version; then
		release="Fedora"
	elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release || grep -Eqi "Ubuntu" /proc/version; then
		release="Ubuntu"
	elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
		release="Raspbian"
	elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
		release="Aliyun"
	else
		release="unknown"
	fi

	if [ ! `command -v wget >/dev/null` ]; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install wget -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget -y
		fi
	fi
}

# 安装 TelegramMessenger MTProxy
install_mtproxy() {
	\rm -rf /opt/MTProxy /usr/local/MTProxy
	mkdir -p /usr/local/MTProxy
	cd /opt
	apt install git curl build-essential libssl-dev zlib1g-dev -y
	git clone https://github.com/TelegramMessenger/MTProxy
	cd MTProxy
	make && cd objs/bin
	mv mtproto-proxy -t /usr/local/MTProxy
}

# 初始化 MTProxy
initialize_mtproxy() {
cd /usr/local/MTProxy
curl -s https://core.telegram.org/getProxySecret -o proxy-secret
curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf

service_mtproxy
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${MTPROXY_PORT} -j ACCEPT
iptables -A OUTPUT -p tcp --sport ${MTPROXY_PORT} -j ACCEPT

iptables-save > /etc/iptables.rules

systemctl daemon-reload
systemctl restart MTProxy.service
systemctl enable MTProxy.service
systemctl status MTProxy.service
}

# 重置 MTProxy
reset_mtproxy() {
	cd /usr/local/MTProxy
	\rm -rf proxy-secret proxy-multi.conf
	curl -s https://core.telegram.org/getProxySecret -o proxy-secret
	curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf

	systemctl stop MTProxy.service
	systemctl disable MTProxy.service
	service_mtproxy
	systemctl daemon-reload
	systemctl enable MTProxy.service
	systemctl start MTProxy.service
	systemctl status MTProxy.service
}

# 创建 MTProxy 服务
service_mtproxy() {
# 获取网络接口名称
interface=$(ip addr | grep '^[0-9]:' | grep -v 'lo' | grep -v 'wg' | cut -d ':' -f2 | awk '{ print $1 }')
# 获取IP地址
local_ip=$(ip addr | grep 'inet ' | grep -v '127.0.0.1' | grep -v '10.0.0.' | cut -d '/' -f1 | awk '{ print $2 }')
# 获取外网IP地址
global_ip=$(curl whatismyip.akamai.com)

read -p "请输入 MTProxy 端口: " MTPROXY_PORT
read -p "请输入 MTProxy 密钥: " MTPROXY_SECRET

if [ "${local_ip}" == ${global_ip} ]
then
cat > ${MTPROXY_SERVICE} << EOF
[Unit]
Description=MTProxy
After=network.target

[Service]
Type=simple
WorkingDirectory=/usr/local/MTProxy
ExecStart=/usr/local/MTProxy/mtproto-proxy -u nobody -p 8888 -H ${MTPROXY_PORT} -S "${MTPROXY_SECRET}" --aes-pwd proxy-secret proxy-multi.conf -M 1
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
else
cat > ${MTPROXY_SERVICE} << EOF
[Unit]
Description=MTProxy
After=network.target

[Service]
Type=simple
WorkingDirectory=/usr/local/MTProxy
ExecStart=/usr/local/MTProxy/mtproto-proxy -u nobody -p 8888 -H ${MTPROXY_PORT} -S "${MTPROXY_SECRET}" --nat-info ${local_ip}:${global_ip} --aes-pwd proxy-secret proxy-multi.conf -M 1
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
fi
}

# 开始菜单
start_menu() {
	clear
	echo "============================="
	echo "环境: 适用于 Debian 9.x"
	echo "Author: allen.w"
	echo "============================="
	echo "1. 安装 TelegramMessenger MTProxy"
	echo "2. 初始化 MTProxy"
	echo "3. 重置 MTProxy"
	echo "4. 退出脚本"
	echo 
	read -p "请输入数字: " num
	case "$num" in
		1)
			install_mtproxy
			;;
		2)
			initialize_mtproxy
			;;
		3)
			reset_mtproxy
			;;
		4)
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