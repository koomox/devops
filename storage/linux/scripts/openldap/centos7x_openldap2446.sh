#!/bin/bash
mkdir /tmp/make_openldap
cd /tmp/make_openldap

groupadd ldap
useradd -r -g ldap -s /bin/false ldap

#########
create database ldap character set utf8mb4 collate utf8mb4_general_ci;
grant all privileges on ldap.* to 'ldap'@'%' identified by 'd5ETG2Ot97IglNQsH7ZQ';
grant all privileges on ldap.* to 'ldap'@'localhost' identified by 'd5ETG2Ot97IglNQsH7ZQ';
flush privileges;
###########

yum install unixODBC-devel -y
#curl -LO https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.0.5/mariadb-connector-odbc-3.0.5-ga-rhel7-x86_64.tar.gz
curl -LO https://gitee.com/koomox/devops/raw/master/storage/linux/libs/mariadb/mariadb-connector-odbc-3.0.5-ga-rhel7-x86_64.tar.gz
tar -zxf mariadb-connector-odbc-3.0.5-ga-rhel7-x86_64.tar.gz -C /usr

curl -LO https://gitee.com/koomox/devops/raw/master/storage/linux/scripts/openldap/2.4.46/odbc.ini
curl -LO https://gitee.com/koomox/devops/raw/master/storage/linux/scripts/openldap/2.4.46/odbcinst.ini
\cp -f odbc.ini /etc/odbc.ini
\cp -f odbcinst.ini /etc/odbcinst.ini

mkdir -p /var/lib/openldap
chown -R ldap:ldap /var/lib/openldap

#curl -LO http://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.46.tgz
curl -LO https://gitee.com/koomox/devops/raw/master/storage/linux/libs/openldap/openldap-2.4.46.tgz
tar -xf openldap-2.4.46.tgz
pushd openldap-2.4.46
./configure --prefix=/usr/local/openldap \
--sysconfdir=/etc \
--disable-bdb \
--disable-hdb \
--disable-mdb \
--enable-sql
make depend
make
make install
popd

touch /etc/ld.so.conf.d/openldap.conf
echo "/usr/local/openldap/lib" > /etc/ld.so.conf.d/openldap.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/openldap/bin:/usr/local/openldap/sbin' >> /etc/profile
source /etc/profile


#####################
mysql -uroot -p
use ldap;
source /tmp/make_openldap/openldap-2.4.46/servers/slapd/back-sql/rdbms_depend/mysql/backsql_create.sql
source /tmp/make_openldap/openldap-2.4.46/servers/slapd/back-sql/rdbms_depend/mysql/testdb_create.sql
source /tmp/make_openldap/openldap-2.4.46/servers/slapd/back-sql/rdbms_depend/mysql/testdb_data.sql
source /tmp/make_openldap/openldap-2.4.46/servers/slapd/back-sql/rdbms_depend/mysql/testdb_metadata.sql
quit
###################

curl -LO https://gitee.com/koomox/devops/raw/master/storage/linux/scripts/openldap/2.4.46/slapd.conf
curl -LO https://gitee.com/koomox/devops/raw/master/storage/linux/scripts/openldap/2.4.46/slapd.service
\cp -f slapd.conf /etc/openldap/slapd.conf
\cp -f slapd.service /usr/lib/systemd/system/slapd.service

chown -R ldap:ldap /etc/openldap

mkdir -p /etc/openldap/certs
openssl req -new -x509 -nodes -out /etc/openldap/certs/ldap.cert -keyout /etc/openldap/certs/ldap.key -days 3650
chown -R ldap:ldap /etc/openldap