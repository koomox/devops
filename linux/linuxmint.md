# Linux Mint             
### 更换源            
```sh
sudo cp /etc/apt/sources.list.d/official-package-repositories.list /etc/apt/sources.list.d/official-package-repositories.list.bak

#Tuna
sudo sed -E -i 's/(http|https):\/\/.*.(linuxmint.com|edu.cn\/linuxmint)/https:\/\/mirrors.tuna.tsinghua.edu.cn\/linuxmint/g' /etc/apt/sources.list.d/official-package-repositories.list
sudo sed -E -i 's/(http|https):\/\/.*.(ubuntu.com|edu.cn)\/ubuntu/https:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu/g' /etc/apt/sources.list.d/official-package-repositories.list

#zju
sudo sed -E -i 's/(http|https):\/\/.*.(linuxmint.com|edu.cn\/linuxmint)/https:\/\/mirrors.zju.edu.cn\/linuxmint/g' /etc/apt/sources.list.d/official-package-repositories.list
sudo sed -E -i 's/(http|https):\/\/.*.(ubuntu.com|edu.cn)\/ubuntu/https:\/\/mirrors.zju.edu.cn\/ubuntu/g' /etc/apt/sources.list.d/official-package-repositories.list

#sudo sed -i 's/http:\/\/.*\//https:\/\/mirrors.tuna.tsinghua.edu.cn\//g' /etc/apt/sources.list.d/official-package-repositories.list

sudo apt update
sudo apt upgrade
```
安装多媒体解码套件          
```sh
sudo apt install mint-meta-codecs
```
安装输入法         
```sh
sudo apt install fcitx fcitx-config-gtk fcitx-ui-classic fcitx-googlepinyin
```