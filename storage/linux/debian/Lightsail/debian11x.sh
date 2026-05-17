#!/bin/bash
if [ "$(whoami)" != "root" ]; then
    SUDO=sudo
fi

echo "===== Update System ===================="
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
echo "Input SSH Port: "
read SSH_PORT
echo "Input SSH Key:"
read SSH_KEY
echo "SSH Port: ${SSH_PORT}"
echo "========= SSH Key ============="
echo "${SSH_KEY}"

if [ ! -x "~/.ssh" ];then
	mkdir -p ~/.ssh
fi
echo -e "${SSH_KEY}" > ~/.ssh/authorized_keys
echo "====== read ~/.ssh/authorized_keys ========"
cat ~/.ssh/authorized_keys

#修改SSH为证书登录
${SUDO} sed -E -i '/^#*Port /cPort '"$SSH_PORT"'' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PermitRootLogin/cPermitRootLogin no' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*MaxAuthTries/cMaxAuthTries 2' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*MaxSessions/cMaxSessions 2' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*MaxStartups/cMaxStartups 2:30:10' /etc/ssh/sshd_config
grep -E "^#*(Port|PermitEmptyPasswords|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|MaxAuthTries|MaxSessions|MaxStartups)" /etc/ssh/sshd_config

echo "======== set iptables rules================"
# INPUT
${SUDO} nft flush ruleset
${SUDO} nft add table inet filter
${SUDO} nft add chain inet filter input { type filter hook input priority 0\; policy accept\; }
${SUDO} nft add chain inet filter forward { type filter hook forward priority 0\; policy accept\; }
${SUDO} nft add chain inet filter output { type filter hook output priority 0\; policy accept\; }
${SUDO} nft add rule inet filter input ct state invalid drop
${SUDO} nft add rule inet filter input meta iif lo ct state new accept
${SUDO} nft add rule inet filter input ct state established,related accept
${SUDO} nft add rule inet filter input tcp dport ${SSH_PORT} accept
${SUDO} nft add rule inet filter input tcp dport 80 accept
${SUDO} nft add rule inet filter input tcp dport 443 accept
${SUDO} nft add chain inet filter input { type filter hook input priority 0\; policy drop\; }
${SUDO} nft add chain inet filter forward { type filter hook forward priority 0\; policy drop\; }
${SUDO} nft list ruleset

echo -e "flush ruleset" | ${SUDO} tee /etc/nftables.conf
echo -e "list ruleset" | ${SUDO} tee -a /etc/nftables.conf
${SUDO} nft --check --file /etc/nftables.conf
${SUDO} systemctl enable nftables
${SUDO} systemctl start nftables
${SUDO} systemctl status nftables

echo "================= Public IP ====================="
curl https://checkip.amazonaws.com/