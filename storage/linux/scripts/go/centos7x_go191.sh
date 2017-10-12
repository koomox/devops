#!/bin/bash
mkdir -p /tmp/go
cd /tmp/go
yum -y install curl
curl -LO https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz
tar -zxf go1.9.1.linux-amd64.tar.gz
\rm -rf /usr/local/go
mv go /usr/local/go
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
source /etc/profile

go env
go version