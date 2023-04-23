# Jupyter       
Home [Link](https://jupyter.org/)        

### Install Jupyterlab       
update system
```sh
sudo apt update -y && sudo apt upgrade -y
```
```sh
pip install jupyterlab
```
run       
```sh
jupyter-lab
```
```sh
sudo groupadd -r jupyter
sudo useradd -r -g jupyter -d /home/jupyter -m jupyter
```
### Setting         
```sh
sudo cp -f  ~/.jupyter/jupyter_lab_config.py ~/.jupyter/jupyter_lab_config.py.bak

sudo sed -i '/^#/d;/^$/d;/^;/d' ~/.jupyter/jupyter_lab_config.py

sudo cat ~/.jupyter/jupyter_lab_config.py
```

```sh
sudo sed -E -i '/^#*c.ServerApp.allow_origin/cc.ServerApp.allow_origin = '"'*'"'' ~/.jupyter/jupyter_lab_config.py
sudo sed -E -i '/^#*c.ServerApp.allow_remote_access/cc.ServerApp.allow_remote_access = True' ~/.jupyter/jupyter_lab_config.py
sudo sed -E -i '/^#*c.ServerApp.token/cc.ServerApp.token = '"''"'' ~/.jupyter/jupyter_lab_config.py
sudo sed -E -i '/^#*c.ServerApp.trust_xheaders/cc.ServerApp.trust_xheaders = True' ~/.jupyter/jupyter_lab_config.py
```
### Nginx       
[source](/storage/linux/scripts/nginx/conf.d/jupyter.conf)           
```sh
sudo wget -O /etc/nginx/conf.d/jupyter.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/jupyter.conf
```

```sh
sudo systemctl stop nginx
sudo systemctl start nginx
```