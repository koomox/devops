#!/bin/bash

jdk_environmental(){
	if grep -Eqi "/usr/local/java/bin" /etc/profile; then
		source /etc/profile
	else
		echo 'export JAVA_HOME=/usr/local/java' >> /etc/profile
		echo 'export CLASSPATH=.:${JAVA_HOME}/lib' >> /etc/profile
		echo 'export PATH=$PATH:${JAVA_HOME}/bin' >> /etc/profile
		source /etc/profile
	fi
}

if [ -e /usr/local/java ]; then
	\rm -rf /usr/local/java
fi

mkdir -p /usr/local/java

sudo tar -zxf jdk-11.0.2_linux-x64_bin.tar.gz -C /usr/local/java --strip-components 1

echo "/usr/local/java/lib" > /etc/ld.so.conf.d/java.conf

ldconfig -v

jdk_environmental
echo "The Java SE Development Kit 11.0.2 install Success!"
java -version