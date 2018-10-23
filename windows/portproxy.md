# 端口映射                      
查看已经配置的“端口映射”列表           
```
netsh interface portproxy show all

netsh interface portproxy show v4tov4
```
添加“端口映射”，把本地1433端口转发到4500端口                  
```
netsh interface portproxy add v4tov4 listenport=1433 connectaddress=192.168.0.88 connectport=4500
```
删除“端口映射”          
```
netsh interface portproxy delete v4tov4 listenport=1433
```

