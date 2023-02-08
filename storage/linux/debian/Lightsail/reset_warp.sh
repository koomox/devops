#!/bin/bash
curl -x socks5://127.0.0.1:1080  https://checkip.amazonaws.com/
warp-cli --accept-tos disconnect
warp-cli --accept-tos connect
curl -x socks5://127.0.0.1:1080  https://checkip.amazonaws.com/