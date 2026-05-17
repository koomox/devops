# Cacti        
Home: [Link](https://www.cacti.net/)          
Download: [Link](https://www.cacti.net/download_cacti.php)          
### 部署 snmp          
`snmpd` server, `snmp` client, `snmp-mibs-downloader` 下载更新本地MIB库          
```sh
apt install snmpd snmp snmp-mibs-downloader
```
```sh
cp -f /etc/default/snmpd /etc/default/snmpd.bak

sed -E -i '/^#*export (.*)MIBS/cexport MIBS=ALL' /etc/default/snmpd
grep -E "^#*export ( *)MIBS=" /etc/default/snmpd
```
```sh
cp -f /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak

sed -ri 's/^#*(agentAddress )(.*)(udp:127.0.0.1:161)(.*)/#\1\2\3\4/g' /etc/snmp/snmpd.conf
sed -ri 's/^#*(agentAddress )(.*)(udp:161)(.*)/\1\2\3\4/g' /etc/snmp/snmpd.conf

sed -ri "s/^#*(rocommunity )(.*)(public )(.*)(localhost)(.*)/\1\2\3\4\5\6/g" /etc/snmp/snmpd.conf

sed -ri "s/^#*(rocommunity )(.*)(secret )(.*)/#\1\2\3\4/g" /etc/snmp/snmpd.conf

grep -E "^#*(agentAddress|rocommunity)( )(.*)" /etc/snmp/snmpd.conf
```
重新启动 snmpd          
```sh
systemctl stop snmpd
systemctl start snmpd
systemctl status snmpd
```
### 部署 Cacti        
创建用户          
```sh
groupadd cacti
useradd  -r -g cacti -s /bin/false cacti
```
```sh
wget https://www.cacti.net/downloads/cacti-1.2.7.tar.gz
wget https://www.cacti.net/downloads/spine/cacti-spine-1.2.7.tar.gz
```