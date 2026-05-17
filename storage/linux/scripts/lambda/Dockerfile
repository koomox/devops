FROM amazonlinux:latest
# install python
RUN yum update -y
RUN yum groupinstall "Development Tools" -y
RUN yum erase openssl-devel -y
RUN yum install openssl11 openssl11-devel libffi-devel bzip2-devel wget -y
RUN wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz
RUN tar -xf Python-3.10.4.tgz
RUN cd Python-3.10.4/ && \
    ./configure --enable-optimizations && \
    make install
RUN ln -s /Python-3.10.4/python /usr/bin/python
RUN python -m pip install --upgrade pip
RUN pip install virtualenv