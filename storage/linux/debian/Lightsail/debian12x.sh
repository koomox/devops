#!/bin/bash
if [ "$(whoami)" != "root" ]; then
    SUDO=sudo
fi

echo "===== Optimize System ============="
${SUDO} apt-get update -y
${SUDO} apt-get upgrade -y
${SUDO} apt-get install curl wget git vim sudo htop net-tools neofetch lsb-release build-essential iputils-ping -y

echo "===== Optimize sysctl.conf ============="
${SUDO} cp -f /etc/sysctl.conf /etc/sysctl.conf.bak
echo -e "net.ipv4.conf.all.rp_filter=0" | ${SUDO} tee /etc/sysctl.conf
echo -e "net.ipv4.conf.default.rp_filter=0" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.conf.default.arp_announce = 2" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.conf.lo.arp_announce=2" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.conf.all.arp_announce=2" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.tcp_max_tw_buckets = 55000" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.tcp_max_syn_backlog = 5000" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.tcp_synack_retries = 2" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "fs.file-max = 60000" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.tcp_syncookies = 1" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.tcp_tw_reuse = 1" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.tcp_tw_recycle = 0" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.tcp_keepalive_time = 1200" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.ip_forward = 1" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "kernel.sysrq = 1" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.core.default_qdisc = fq" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.ipv4.tcp_congestion_control = bbr" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.core.netdev_max_backlog = 55000" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.core.somaxconn = 10000" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.nf_conntrack_max = 65536000" | ${SUDO} tee -a /etc/sysctl.conf
echo -e "net.netfilter.nf_conntrack_tcp_timeout_established = 1200" | ${SUDO} tee -a /etc/sysctl.conf
${SUDO} modprobe ip_conntrack
lsmod |grep conntrack
${SUDO} sysctl -p
${SUDO} sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr

echo "===== Optimize limits.conf ============="
${SUDO} cp -f /etc/security/limits.conf /etc/security/limits.conf.bak
echo -e "*         hard    nofile      524288" | ${SUDO} tee /etc/security/limits.conf
echo -e "*         soft    nofile      524288" | ${SUDO} tee -a /etc/security/limits.conf
echo -e "*         hard    nproc       unlimited" | ${SUDO} tee -a /etc/security/limits.conf
echo -e "*         soft    nproc       unlimited" | ${SUDO} tee -a /etc/security/limits.conf
echo -e "*         hard    core        unlimited" | ${SUDO} tee -a /etc/security/limits.conf
echo -e "*         soft    core        unlimited" | ${SUDO} tee -a /etc/security/limits.conf
echo -e "root      hard    nofile      524288" | ${SUDO} tee -a /etc/security/limits.conf
echo -e "root      soft    nofile      524288" | ${SUDO} tee -a /etc/security/limits.conf
echo -e "root      hard    nproc       unlimited" | ${SUDO} tee -a /etc/security/limits.conf
echo -e "root      soft    nproc       unlimited" | ${SUDO} tee -a /etc/security/limits.conf
echo -e "root      hard    core        unlimited" | ${SUDO} tee -a /etc/security/limits.conf
echo -e "root      soft    core        unlimited" | ${SUDO} tee -a /etc/security/limits.conf
cat /etc/security/limits.conf

${SUDO} sed -E -i '/^#*DefaultLimitNOFILE=/cDefaultLimitNOFILE=524288' /etc/systemd/system.conf
grep -E '^#*DefaultLimitNOFILE=' /etc/systemd/system.conf

echo "===== Optimize timedatectl ============"
${SUDO} apt install dbus -y
${SUDO} timedatectl set-timezone Asia/Singapore
timedatectl

echo "===== Custom SSH Port And Iptabes Rules ========="
echo "input SSH Port: "
read SSH_PORT
echo "SSH Port: ${SSH_PORT}"

echo "===== reset iptables rules======"
${SUDO} iptables -P INPUT ACCEPT
${SUDO} iptables -P FORWARD ACCEPT
${SUDO} iptables -P OUTPUT ACCEPT
${SUDO} iptables -F
${SUDO} iptables -X
${SUDO} iptables -Z
${SUDO} iptables -nvL

#修改SSH为证书登录
${SUDO} sed -E -i '/^#*Port /cPort '"$SSH_PORT"'' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PermitRootLogin/cPermitRootLogin no' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' /etc/ssh/sshd_config

echo "======== set iptables rules================"

# INPUT
${SUDO} iptables -A INPUT -i lo -j ACCEPT
${SUDO} iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
${SUDO} iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${SSH_PORT} -j ACCEPT
${SUDO} iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
${SUDO} iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

${SUDO} systemctl restart sshd

${SUDO} iptables -P INPUT DROP
${SUDO} iptables -P FORWARD DROP
${SUDO} iptables -P OUTPUT ACCEPT

${SUDO} iptables-save > /etc/iptables.rules

${SUDO} systemctl enable rc-local
${SUDO} systemctl start rc-local
echo -e "#!/bin/sh -e" | ${SUDO} tee /etc/rc.local
echo -e "iptables-restore < /etc/iptables.rules" | ${SUDO} tee -a /etc/rc.local
echo -e "exit 0" | ${SUDO} tee -a /etc/rc.local
${SUDO} chmod +x /etc/rc.local

${SUDO} iptables -nvL

echo "================= Public IP ====================="
curl https://checkip.amazonaws.com/