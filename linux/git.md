# git 命令            
### SSH 证书         
生成 ssh 公钥和私钥           
```sh
ssh-keygen -t rsa -b 4096 -C "email@example.com" -f example.com.key
```
### 设置用户信息        
因为Git是分布式系统，所以在使用Git之前，必须先设置用户信息（包括用户名和邮件地址）          
```
git config --global user.name "Your Name"  # 设置和修改用户信息
git config --global user.email "email@example.com"

git config --global http.postBuffer 524288000    # git 文件上传大小默认为1M，如果超过1M就无法上传，500M
git config --global --list
git config --global --add user.name "Your Name" # 添加一个配置项
git config --global --get user.name  # 获取一个配置项
git config --global --unset user.name "Your Name" # 删除一个配置项
```	
注意：`git config` 命令的 `--global` 参数，用了这个参数，表示你这台机器上的所有 Git 仓库都会使用这个配置，当然也可以对某个仓库指定不同的用户名和Email地址。                

查看配置           
```
git config --local -l   #查看仓库级配置
git config --global -l   #查看全局级配置
git config --system -l   #查看系统级配置

git config --local --list   #查看仓库级配置
git config --global --list   #查看全局级配置
git config --system --list   #查看系统级配置
```
用户设置单个仓库           
```
git init

git config user.name "Your Name"  # 设置和修改用户信息
git config user.email "email@example.com"
git config http.postBuffer 524288000   # git 文件上传大小默认为1M，如果超过1M就无法上传，500M

git config http.proxy socks5://127.0.0.1:1080  # 设置代理

git remote add origin git@gihtub.com:username/repo.git

git add -A
git commit -m "first commit"
git push -u origin master
```
### 设置全局代理             
在某些网络环境下，你可能需要为 Git 配置代理，这很简单，只需要一行命令就可以了。        
```
git config --global https.proxy https://user:password@calssfoo.com
```
### 分支管理         
`git branch` 列出本地已经存在的分支，并且在当前分支的前面加`*`号标记。          
```
git branch  # 列出本地已经存在的分支
git branch -r  # 列出远程分支
git branch -a  # 列出本地和远程分支
```
创建一个本地分支，如下命令，但是这只是创建了一个名为 dev 的分支，不进行切换。        
```
git branch dev
```
`git branch -m` 重命名分支，如果 newbranch 名字分支已经存在，则需要使用-M强制重命名，否则，使用`-m`进行重命名。        
```
git branch -m oldbranch newbranch
```
`git branch -d`删除分支            
```
git branch -d branchname # 删除branchname分支
git branch -d -r branchname # 删除远程分支
```
### 远程分支          
`git remote` 列出已经存在的远程分支的短名称。         
`git remote -v|--verbose` 列出详细信息，在每一个名字后面列出其远程URL         

添加一个新的远程分支，可以指定一个简单的名字，以便将来引用。如下命令，远程分支名称为origin。           
```
git remote add origin git://github.com/xx/xx.git
```
添加SSH协议的GIT远程分支，有两种方式            
```
git remote add origin ssh://username@domain.com:port/srv/git/code.git  # 支持自定义SSH端口
git remote add origin username@domain.com:/srv/git/code.git  # 不支持自定义SSH端口

git remote add develop git://
```
删除远程分支         
```
git remote rm origin
```
重命名远程分支         
```
git remote rename oldname newname
```

### 提交          
提交所有更新到远程分支         
```
git add -A
git commit -am "update"
git push
```
```
git push origin master
```
拉取远程分支合并到本地分支           
```
git fetch origin master
git log -p master..origin/master
git merge origin/master
```
```
git fetch origin master:tmp
git diff tmp
git merge tmp
```
```
git pull origin master
```
### git 强制覆盖本地代码                
```sh
git fetch --all
git reset --hard origin/master
git pull
```
### 在线仓库                
gitee.com 在线仓库的raw文件地址              
```
https://gitee.com/koomox/devops/raw/master
```
github.com 在线仓库的raw文件地址               
```
https://raw.githubusercontent.com/koomox/devops/master
```
coding.net 在线仓库的raw文件地址           
```
https://coding.net/u/koomox/p/devops/git/raw/master
```
sed 命令替换网址字符串         
```sh
sed -i 's/https:\/\/gitee.com\/koomox\/devops\/raw\/master/https:\/\/raw.githubusercontent.com\/koomox\/devops\/master/g' file
```
### 创建 git 仓库         
一键创建 git 仓库 [查看源文件](../storage/linux/scripts/git/git_storage.sh)             
```sh
curl -s https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/git/git_storage.sh -o /tmp/git_storage.sh
chmod +x /tmp/git_storage.sh
/tmp/git_storage.sh
```
### 基于 git 的代码自动化部署          
一键创建基于 git 的web 自动化部署 [查看源文件](../storage/linux/scripts/git/git_webdeploy.sh)            
```sh
curl -s https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/git/git_webdeploy.sh -o /tmp/git_webdeploy.sh
chmod +x /tmp/git_webdeploy.sh
/tmp/git_webdeploy.sh
```
### 常用命令             
删除当前目录及子目录下的 `.git` 文件夹           
```sh
find . -name ".git" | xargs rm -Rf
```