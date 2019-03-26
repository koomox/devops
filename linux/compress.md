# 压缩、解压命令             
## tar           
| 参数  | 详解 |
|:----:|------|
| -c | 建立压缩归档文件 |
| -x | 解压压缩归档文件 |
| -t | 查看压缩归档文件内容 |
| -r | 向压缩归档文件末尾追加文件 |
| -u | 更新原压缩包中的文件 |
| -z | 调用 `gzip` 进行解压缩 `.gz` 文件 |
| -j | 调用 `bzip2` 进行解压缩 `.bz2` 文件 |
| -J | .xz |
| -Z | .compress |
| -v | 显示处理过程 |
| -O | 将文件解开到标准输出 |
| -f | 档案文件名称，必须是最后一个参数，后面只能接档案文件名称。 |
               
压缩文件                       
```sh
tar -zcvf /path/to/file.tar.gz file
tar -zcvf file.tar.gz file
```
解压文件       
```sh
tar -zxvf /path/to/file.tar.gz /path/to
```
加密压缩         
```sh
tar -zcvf - file | openssl des3 -salt -k "password" -out /path/to/file.tar.gz
```
解密解压         
```sh
openssl des3 -d -k "password" -salt -in /path/to/file.tar.gz | tar zxf -
```
解密解压到指定目录            
```sh
openssl des3 -d -k "password" -salt -in /path/to/file.tar.gz | tar zx -C /path/to
```
压缩并分割文件           
```sh
tar czf - rust | split -b 500M - rust.tar.gz
```
合并解压文件            
```sh
cat rust.tar.gz* | tar -zxv
```