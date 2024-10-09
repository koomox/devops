# Redis         
## Install on Ubuntu/Debian       
```sh
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt-get update
sudo apt-get install redis
```

```sh
sudo cp -f /etc/redis/redis.conf /etc/redis/redis.conf.bak

sudo sed -E -i '/^#*requirepass/crequirepass' /etc/redis/redis.conf

sudo sed -i '/^#/d;/^$/d;/^;/d' /etc/redis/redis.conf
```

```sh
sudo systemctl stop redis-server
sudo systemctl start redis-server
sudo systemctl status redis-server
```

openssl generate a random string      
```sh
openssl rand -base64 30 | sha256sum
```