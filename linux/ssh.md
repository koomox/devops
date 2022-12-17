# SSH            
OpenSSH : [Link](https://www.openssh.com/)           
### 安装 OpenSSH          
debian 安装 openssh        
```sh
apt install -y openssh-server openssh-client
```
### 设置 SSH        
启用 root 远程登录         
```sh
sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
```
启用 SSH 证书登录           
```sh
sed -E -i '/^#*Port /cPort '"$SSH_PORT"'' /etc/ssh/sshd_config

sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' /etc/ssh/sshd_config
sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' /etc/ssh/sshd_config

grep -E "^#*(Port|PermitEmptyPasswords|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication)" /etc/ssh/sshd_config
```
生成 ssh 公钥和私钥           
```sh
ssh-keygen -t rsa -b 4096 -C "email@example.com" -f example.com.key
```
设置 ssh 证书         
```sh
rm -rf ~/.ssh
rm -rf ~/.ssh/authorized_keys
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
vim ~/.ssh/authorized_keys
```
### ssh client 设置        
修复ssh远程链接断开，无响应的问题。每隔60秒发送一次心跳，若超过3次请求，都没有发送成功，则会主动断开与服务器之间的连接。
```sh
echo -e "    ServerAliveCountMax 3\n    ServerAliveInterval 60" | sudo tee -a /etc/ssh/ssh_config
```
ssh 连接远程主机配置文件 `~/.ssh/config`       
```
Host example.com
    HostName 127.0.0.1
    Port 22
    User root
```
证书登陆      
```
Host example.com
    HostName 127.0.0.1
    Port 22
    User ubuntu
    IdentityFile ~/.ssh/id_rsa.key
```
通过 socks5 代理连接远程主机       
```
Host example.com
    HostName 127.0.0.1
    Port 22
    User ubuntu
    IdentityFile ~/.ssh/id_rsa.key
    ProxyCommand nc -X 5 -x 127.0.0.1:1080 %h %p
```
### github 上传         
修复 git 无法上次的问题          
```sh
mkdir -p ~/.ssh
echo -e "Host *\n\tIPQoS lowdelay throughput" > ~/.ssh/config
chmod -R 600 ~/.ssh/config
cat ~/.ssh/config
```
添加 ssh 证书        
```sh
eval $(ssh-agent -s)
ssh-add ~/.ssh/github.com.key
```
clone、upload               
```sh
git clone git@github.com:xtaci/chat.git

cd chat
git add -A
git commit -am "upload"
git push origin master
```