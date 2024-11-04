# Redis         
## Install on Ubuntu/Debian       
```sh
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt-get update
sudo apt-get install redis

redis-server -v
```
Configure Redis       
```sh
sudo cp -f /etc/redis/redis.conf /etc/redis/redis.conf.bak

sudo sed -E -i '/^#*requirepass/crequirepass' /etc/redis/redis.conf

sudo sed -i '/^#/d;/^$/d;/^;/d' /etc/redis/redis.conf
```
#### Network security        
Note that it is possible to bind Redis to a single interface by adding a line like the following to the `redis.conf` file:          
```sh
bind 127.0.0.1
```
#### Disallowing specific commands         
It is possible to disallow commands in Redis or to rename them as an unguessable name, so that normal clients are limited to a specified set of commands.        
```
rename-command CONFIG b840fc02d524045429941cc15f59e41cb7be6c52
rename-command SHUTDOWN FCKTGTdPVw8v7XbvNOTDf8vJ3o2PxX1uh2P2BHs
```
Rename dangerous commands           
```sh
echo "rename-command CONFIG \"$(openssl rand -base64 30 | sha256sum | awk '{print $1}')\"" | sudo tee -a /etc/redis/redis.conf
echo "rename-command SHUTDOWN \"$(openssl rand -base64 30 | sha256sum | awk '{print $1}')\"" | sudo tee -a /etc/redis/redis.conf
echo "rename-command FLUSHALL \"$(openssl rand -base64 30 | sha256sum | awk '{print $1}')\"" | sudo tee -a /etc/redis/redis.conf
echo "rename-command FLUSHDB \"$(openssl rand -base64 30 | sha256sum | awk '{print $1}')\"" | sudo tee -a /etc/redis/redis.conf
echo "rename-command DEBUG \"$(openssl rand -base64 30 | sha256sum | awk '{print $1}')\"" | sudo tee -a /etc/redis/redis.conf
```
In the above example, the CONFIG command was renamed into an unguessable name. It is also possible to completely disallow it (or any other command) by renaming it to the empty string, like in the following example:          
```
rename-command CONFIG ""
rename-command SHUTDOWN ""
rename-command FLUSHALL ""
rename-command FLUSHDB ""
rename-command DEBUG ""
```
#### requirepass                
Thus, it’s important that you specify a very strong and very long value as your password. Rather than make up a password yourself, you can use the `openssl` command to generate a random one, as in the following example. The pipe to the second `openssl` command will remove any line breaks that are output by the first command:             
```sh
openssl rand 60 | openssl base64 -A
```
After copying and pasting the output of that command as the new value for requirepass, it should read:           
```
requirepass cdkLVzLk6aSPqEvQBOW3eqLQtF5eH3qtaM+JKH2GcGHtBHjLOYHbKICIWMRc+XXbnliZbJPSDEzF6qDc
```
#### Security model              
Navigate to your `redis.conf` file, Uncomment the following line in the config file               
Enable protected mode (optional, depending on your setup)          
```
protected-mode yes
```
Save and close the file, then restart the Redis service           
```sh
sudo systemctl enable redis-server
sudo systemctl stop redis-server
sudo systemctl start redis-server
sudo systemctl status redis-server
```
Listening Ports       
```sh
ps -ef | grep redis
```
openssl generate a random string      
```sh
openssl rand -base64 30 | sha256sum
```
#### Ping Testing the Redis Service          
```sh
redis-cli
```
Then, authenticate yourself with the password that you have set:          
```
auth your_redis_password
```
We assumed that you rename the `config` command to `b840fc02d524045429941cc15f59e41cb7be6c52`. If you use config you will get an error:             
```
config get requirepass
```
You should use the renamed command:        
```
b840fc02d524045429941cc15f59e41cb7be6c52 get requirepass
```

Now you can exit from the Redis client with the `exit` or `quit` command.