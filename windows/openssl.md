# OpenSSL         
[Home](https://www.openssl.org/source/)            
[NASM](https://nasm.us/)          
[Perl](https://strawberryperl.com/)             
### 编译          
安装 NASM 和 PERL以后，进入 OPENSSL源码目录        
```
cd /d C:\openssl-3.1.4
```
如果编译静态链接版本的二进制程序，加一个 no-shared 选项即可, 32位 VC-WIN32， 64位 VC-WIN64A。 编译后安装在  D:\openssl-3.1.4      
```
perl Configure VC-WIN64A no-asm no-shared --prefix=D:\openssl-3.1.4
```