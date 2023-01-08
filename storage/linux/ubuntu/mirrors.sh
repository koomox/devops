#!/bin/bash
echo "deb http://cn.archive.ubuntu.com/ubuntu $(lsb_release -sc) main restricted universe multiverse" >> /etc/apt/sources.list
echo "# deb-src http://cn.archive.ubuntu.com/ubuntu $(lsb_release -sc) main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://cn.archive.ubuntu.com/ubuntu $(lsb_release -sc)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "# deb-src http://cn.archive.ubuntu.com/ubuntu $(lsb_release -sc)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://cn.archive.ubuntu.com/ubuntu $(lsb_release -sc)-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "# deb-src http://cn.archive.ubuntu.com/ubuntu $(lsb_release -sc)-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "# deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner" >> /etc/apt/sources.list
echo "# deb-src http://archive.canonical.com/ubuntu $(lsb_release -sc) partner" >> /etc/apt/sources.list
echo "deb http://cn.archive.ubuntu.com/ubuntu $(lsb_release -sc)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "# deb-src http://cn.archive.ubuntu.com/ubuntu $(lsb_release -sc)-security main restricted universe multiverse" >> /etc/apt/sources.list