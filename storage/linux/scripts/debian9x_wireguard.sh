#!/bin/bash
PUBLIC_PORT=5123
WG_CONF=/etc/wireguard/wg0.conf 
CLIENT_CONF=/etc/wireguard/client.conf

apt install curl -y

# 获取网络接口名称
interface=$(ip addr | grep '^[0-9]:' | grep -v 'lo' | cut -d ':' -f2 | awk '{ print $1 }')
# 获取IP地址
local_ip=$(ip addr | grep 'inet ' | grep -v '127.0.0.1' | cut -d '/' -f1 | awk '{ print $2 }')
# 获取外网IP地址
global_ip=$(curl whatismyip.akamai.com)

# 更新软件包源
apt update

# 安装和 linux-image 内核版本相对于的 linux-headers 内核
apt install linux-headers-$(uname -r) -y

# Debian9 安装后内核列表
dpkg -l|grep linux-headers

# 添加 unstable 软件包源，以确保安装版本是最新的
echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
echo -e 'Package: *\nPin: release a=unstable\nPin-Priority: 150' > /etc/apt/preferences.d/limit-unstable

# 更新一下软件包源
apt update

# 开始安装 WireGuard
apt install wireguard -y

# 验证是否安装成功
modprobe wireguard && lsmod | grep wireguard

# 配置步骤 WireGuard服务端

# 首先进入配置文件目录
mkdir -p /etc/wireguard
cd /etc/wireguard

# 然后开始生成 密匙对(公匙+私匙)。
wg genkey | tee sprivatekey | wg pubkey > spublickey
wg genkey | tee cprivatekey | wg pubkey > cpublickey

# 生成服务端配置文件
cat > ${WG_CONF} << EOF
[Interface]
# 私匙，自动读取上面刚刚生成的密匙内容
PrivateKey = $(cat sprivatekey)
# VPN中本机的内网IP，一般默认即可，除非和你服务器或客户端设备本地网段冲突
Address = 10.0.0.1/24 
# 运行 WireGuard 时要执行的 iptables 防火墙规则，用于打开NAT转发之类的。
# 如果你的服务器主网卡名称不是 eth0 ，那么请修改下面防火墙规则中最后的 eth0 为你的主网卡名称。
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ${interface} -j MASQUERADE
# 停止 WireGuard 时要执行的 iptables 防火墙规则，用于关闭NAT转发之类的。
# 如果你的服务器主网卡名称不是 eth0 ，那么请修改下面防火墙规则中最后的 eth0 为你的主网卡名称。
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ${interface} -j MASQUERADE
# 服务端监听端口，可以自行修改
ListenPort = ${PUBLIC_PORT}
# 服务端请求域名解析 DNS
DNS = 8.8.8.8
# 保持默认
MTU = 1300
[Peer]
# 公匙，自动读取上面刚刚生成的密匙内容
PublicKey = $(cat cpublickey)
# VPN内网IP范围，一般默认即可，除非和你服务器或客户端设备本地网段冲突
AllowedIPs = 10.0.0.2/32
EOF


# 生成客户端配置文件
cat > ${CLIENT_CONF} << EOF
[Interface]
# 私匙，自动读取上面刚刚生成的密匙内容
PrivateKey = $(cat cprivatekey)
# VPN内网IP范围
Address = 10.0.0.2/24
# 解析域名用的DNS
DNS = 8.8.8.8
# 保持默认
MTU = 1300
# Wireguard客户端配置文件加入PreUp,Postdown命令调用批处理文件
PreUp = start   ..\route\routes-up.bat
PostDown = start  ..\route\routes-down.bat
#### 正常使用Tunsafe点击connect就会调用routes-up.bat将国内IP写进系统路由表，断开disconnect则会调用routes-down.bat删除路由表。
[Peer]
# 公匙，自动读取上面刚刚生成的密匙内容
PublicKey = $(cat spublickey)
# 服务器地址和端口，下面的 X.X.X.X 记得更换为你的服务器公网IP，端口根据服务端配置时的监听端口填写
Endpoint = ${global_ip}:${PUBLIC_PORT}
# 转发流量的IP范围，下面这个代表所有流量都走VPN
AllowedIPs = 0.0.0.0/0, ::0/0
# 保持连接，如果客户端或服务端是 NAT 网络(比如国内大多数家庭宽带没有公网IP，都是NAT)，
# 那么就需要添加这个参数定时链接服务端(单位：秒)，如果你的服务器和你本地都不是 NAT 网络，
# 那么建议不使用该参数（设置为0，或客户端配置文件中删除这行）
PersistentKeepalive = 25
EOF

sed -i '/^#/d' ${WG_CONF}
sed -i '/^$/d' ${WG_CONF}
sed -i '/^#/d' ${CLIENT_CONF}
sed -i '/^$/d' ${CLIENT_CONF}

# 打开防火墙转发功能
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# 显示配置文件，可以修改里面的实际IP
echo "================= ${WG_CONF} ======================="
cat ${WG_CONF}
echo "================= ${CLIENT_CONF} ======================="
cat ${CLIENT_CONF}