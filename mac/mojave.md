# 制作 macOS Mojave 10.14 系统镜像cdr、ISO文件，可用虚拟机安装              
```sh
hdiutil create -o /tmp/Mojave.cdr -size 8g -layout SPUD -fs HFS+J
hdiutil attach /tmp/Mojave.cdr.dmg -noverify -mountpoint /Volumes/install_build
sudo /Applications/Install\ macOS\ Mojave\ 10.14.3.app/Contents/Resources/createinstallmedia --volume /Volumes/install_build
mv /tmp/Mojave.cdr.dmg ~/Desktop/InstallSystem.dmg
hdiutil detach /Volumes/Install\ macOS\ Mojave\ 10.14.3
hdiutil convert ~/Desktop/InstallSystem.dmg -format UDTO -o ~/Desktop/Mojave.iso
```
### 制作 macOS Cataline 10.15 系统镜像cdr、ISO文件，可用虚拟机安装              
```sh
hdiutil create -o /tmp/Catalina.cdr -size 8g -layout SPUD -fs HFS+J
hdiutil attach /tmp/Catalina.cdr.dmg -noverify -mountpoint /Volumes/install_build
sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/install_build
mv /tmp/Catalina.cdr.dmg ~/Desktop/InstallSystem.dmg
hdiutil detach /Volumes/Install\ macOS\ Catalina
hdiutil convert ~/Desktop/InstallSystem.dmg -format UDTO -o ~/Desktop/Catalina.iso
```
