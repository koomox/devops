#!/bin/bash
wget -O /etc/network/if-pre-up.d/iptables https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/iptables/up.iptables
chmod +x /etc/network/if-pre-up.d/iptables
wget -O /etc/iptables.up.rules https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/iptables/iptables.rules.sh