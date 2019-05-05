#!/bin/bash
wget -O /etc/network/if-pre-up.d/iptables https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/iptables/up.iptables
chmod +x /etc/network/if-pre-up.d/iptables

wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/iptables/iptables.rules.sh
chmod +x ./iptables.rules.sh
./iptables.rules.sh

# mv /etc/iptables.rules /etc/iptables.up.rules