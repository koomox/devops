#!/bin/bash
if [ "$(whoami)" != "root" ]; then
    SUDO=sudo
fi

echo "===== Optimize System ============="
curl https://pkg.cloudflareclient.com/pubkey.gpg | ${SUDO} gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | ${SUDO} tee /etc/apt/sources.list.d/cloudflare-client.list
${SUDO} apt-get update -y
${SUDO} apt-get upgrade -y
${SUDO} apt-get install cloudflare-warp -y

echo "Cloudflare WARP Account Registration in progress..."
warp-cli --accept-tos register

echo "Setting up WARP Proxy Mode..."
warp-cli --accept-tos set-mode proxy

echo "Setting up WARP Proxy Socks5 Port..."
warp-cli --accept-tos set-proxy-port 1080

echo "Connecting to WARP..."
warp-cli --accept-tos connect

echo "Enable WARP Always-On..."
warp-cli --accept-tos enable-always-on

echo "Status check in progress..."
warp-cli warp-stats

echo "check WARP Proxy Setting..."
warp-cli --accept-tos settings

curl https://checkip.amazonaws.com/

curl -x socks5://127.0.0.1:1080  https://checkip.amazonaws.com/