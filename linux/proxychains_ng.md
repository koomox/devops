# proxychains-ng         
github: [Link](https://github.com/rofl0r/proxychains-ng)         
sourceforge: [Link](https://sourceforge.net/projects/proxychains-ng/files/)           

### install    
proxychains.conf [source](/storage/linux/scripts/proxychains4/proxychains.conf)         
```sh
git clone https://github.com/rofl0r/proxychains-ng.git --depth=1
cd proxychains-ng
./configure --prefix=/usr --sysconfdir=/etc
make
make install
make install-config

\cp -f src/proxychains.conf /etc/proxychains.conf
sed -i '/^#/d;/^$/d' /etc/proxychains.conf

proxychains4 printenv
```