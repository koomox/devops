# OpenSUSE               
#### 更新源            
备份       
```sh
cp /etc/zypp/repos.d/repo-oss.repo /etc/zypp/repos.d/repo-oss.repo.bak
cp /etc/zypp/repos.d/repo-non-oss.repo /etc/zypp/repos.d/repo-non-oss.repo.bak
cp /etc/zypp/repos.d/repo-update-non-oss.repo /etc/zypp/repos.d/repo-update-non-oss.repo.bak
cp /etc/zypp/repos.d/repo-update.repo /etc/zypp/repos.d/repo-update.repo.bak
```
替换源          
```sh
sudo sed -i 's/http:\/\/download.opensuse.org/https:\/\/mirrors.tuna.tsinghua.edu.cn\/opensuse/g' /etc/zypp/repos.d/repo-oss.repo
sudo sed -i 's/http:\/\/download.opensuse.org/https:\/\/mirrors.tuna.tsinghua.edu.cn\/opensuse/g' /etc/zypp/repos.d/repo-non-oss.repo

sudo sed -i 's/http:\/\/download.opensuse.org/https:\/\/mirrors.tuna.tsinghua.edu.cn\/opensuse/g' /etc/zypp/repos.d/repo-update-non-oss.repo
sudo sed -i 's/http:\/\/download.opensuse.org/https:\/\/mirrors.tuna.tsinghua.edu.cn\/opensuse/g' /etc/zypp/repos.d/repo-update.repo
```
手动刷新软件源           
```sh
sudo zypper ref
```
更新         
```sh
sudo zypper up
```
更新还是不行，重启系统后，总算能正常更新了。          
查看 zypper 软件源         
```sh
sudo zypper lr -u
```
### 安装软件          
```sh
sudo zypper install htop
```