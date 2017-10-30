#!/bin/bash
SELINUX_CONF="/etc/selinux/config"
SSH_CONF="/etc/ssh/sshd_config"
SSH_PORT=22

echo "========= setting SSH and internat ip and ipsec secrets ======"
echo "please input SSH PORT: "
read SSH_PORT
echo "========= SSH PORT ============="
echo "${SSH_PORT}"

echo "===== reset iptables rules======"
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X
iptables -Z
service iptables save
service iptables restart
iptables -nvL

#修改SSH为证书登录
setenforce 0
echo -e "#SELINUX=enforcing\n#SELINUXTYPE=targeted\nSELINUX=disabled\nSETLOCALDEFS=0" > ${SELINUX_CONF}
sed -i '/Port /c Port '"$SSH_PORT"'' ${SSH_CONF}
sed -i '/PermitEmptyPasswords no/c #PermitEmptyPasswords no' ${SSH_CONF}
sed -i '/PermitRootLogin yes/c #PermitRootLogin yes' ${SSH_CONF}
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' ${SSH_CONF}

echo "======== set iptables rules================"
yum -y install iptables-services
systemctl mask firewalld.service
systemctl enable iptables.service
systemctl stop firewalld
systemctl start iptables

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
iptables -X
iptables -Z
#iptables -t nat -F

# INPUT
iptables -A INPUT -i lo -j ACCEPT
# iptables -A INPUT -m icmp -p icmp --icmp-type any -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${SSH_PORT} -j ACCEPT
iptables -A INPUT -m state --state NEW -m udp -p udp --sport 123 -j ACCEPT
iptables -A INPUT -p tcp --sport 16630 -j ACCEPT

# OUTPUT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m icmp -p icmp --icmp-type any -j ACCEPT

iptables -A OUTPUT -p tcp --sport ${SSH_PORT} -j ACCEPT

iptables -A OUTPUT -p tcp --dport 21 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 16630 -j ACCEPT

### Outlook.com
iptables -A OUTPUT -p tcp --dport 993 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 587 -j ACCEPT

### gmail
iptables -A OUTPUT -p tcp --dport 995 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 465 -j ACCEPT

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP


service iptables save
service iptables restart
iptables -nvL

systemctl restart sshd.service
systemctl status sshd.service