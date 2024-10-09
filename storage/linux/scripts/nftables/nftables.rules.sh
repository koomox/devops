#!/bin/bash
read -p "请输入 SSH 端口: " SSH_PORT
cat > /etc/nftables.conf << EOF
flush ruleset
table inet filter {
	chain input {
		type filter hook input priority filter; policy drop;
		ct state invalid drop
		iif "lo" ct state new accept
		ct state established,related accept
		tcp dport ${SSH_PORT} accept
		tcp dport 80 accept
		tcp dport 443 accept
	}

	chain forward {
		type filter hook forward priority filter; policy drop;
	}

	chain output {
		type filter hook output priority filter; policy accept;
	}
}
EOF

nft --check --file /etc/nftables.conf
cat /etc/nftables.conf