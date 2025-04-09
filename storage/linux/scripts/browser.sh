#!/bin/bash
FIREFOX_VERSION=137.0.1
FIREFOX_DEVELOPER_EDITION_VERSION=138.0b4
TOR_VERSION=14.0.9
APPGUID=8A69D345-D564-463C-AFF1-A69D9E530F96
ID=754CC110-B9C8-798B-4231-9054058921FC
DATETIME=$(date +%Y%m%d)
\rm -rf ./temp
mkdir -p ./temp
cd ./temp

wget -O en_ChromeStandaloneSetup64_${DATETIME}.exe https://dl.google.com/tag/s/appguid%3D%7B${APPGUID}%7D%26iid%3D%7B${ID}%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup64.exe
wget -O en_ChromeStandaloneSetup_${DATETIME}.exe https://dl.google.com/tag/s/appguid%3D%7B${APPGUID}%7D%26iid%3D%7B${ID}%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx86-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup.exe
wget -O zhCN_ChromeStandaloneSetup64_${DATETIME}.exe https://dl.google.com/tag/s/appguid%3D%7B${APPGUID}%7D%26iid%3D%7B${ID}%7D%26lang%3Dzh-CN%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup64.exe
wget -O zhCN_ChromeStandaloneSetup_${DATETIME}.exe https://dl.google.com/tag/s/appguid%3D%7B${APPGUID}%7D%26iid%3D%7B${ID}%7D%26lang%3Dzh-CN%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx86-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup.exe
wget -O googlechrome_${DATETIME}.dmg https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg
wget -O google-chrome-stable_current_amd64_${DATETIME}.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

wget -O en_Firefox_Developer_Edition_x64_${FIREFOX_DEVELOPER_EDITION_VERSION}.exe https://download-installer.cdn.mozilla.net/pub/devedition/releases/${FIREFOX_DEVELOPER_EDITION_VERSION}/win64/en-US/Firefox%20Setup%20${FIREFOX_DEVELOPER_EDITION_VERSION}.exe
wget -O en_Firefox_Developer_Edition_x86_${FIREFOX_DEVELOPER_EDITION_VERSION}.exe https://download-installer.cdn.mozilla.net/pub/devedition/releases/${FIREFOX_DEVELOPER_EDITION_VERSION}/win32/en-US/Firefox%20Setup%20${FIREFOX_DEVELOPER_EDITION_VERSION}.exe
wget -O zhCN_Firefox_Developer_Edition_x64_${FIREFOX_DEVELOPER_EDITION_VERSION}.exe https://download-installer.cdn.mozilla.net/pub/devedition/releases/${FIREFOX_DEVELOPER_EDITION_VERSION}/win64/zh-CN/Firefox%20Setup%20${FIREFOX_DEVELOPER_EDITION_VERSION}.exe
wget -O zhCN_Firefox_Developer_Edition_x86_${FIREFOX_DEVELOPER_EDITION_VERSION}.exe https://download-installer.cdn.mozilla.net/pub/devedition/releases/${FIREFOX_DEVELOPER_EDITION_VERSION}/win32/zh-CN/Firefox%20Setup%20${FIREFOX_DEVELOPER_EDITION_VERSION}.exe

wget -O en_Firefox_x64_${FIREFOX_VERSION}.exe https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/win64/en-US/Firefox%20Setup%20${FIREFOX_VERSION}.exe
wget -O en_Firefox_x86_${FIREFOX_VERSION}.exe https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/win32/en-US/Firefox%20Setup%20${FIREFOX_VERSION}.exe
wget -O zhCN_Firefox_x64_${FIREFOX_VERSION}.exe https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/win64/zh-CN/Firefox%20Setup%20${FIREFOX_VERSION}.exe
wget -O zhCN_Firefox_x86_${FIREFOX_VERSION}.exe https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/win32/zh-CN/Firefox%20Setup%20${FIREFOX_VERSION}.exe

wget -O torbrowser-install-${TOR_VERSION}_en-US.exe https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/torbrowser-install-${TOR_VERSION}_en-US.exe
wget -O torbrowser-install-win64-${TOR_VERSION}_en-US.exe https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/torbrowser-install-win64-${TOR_VERSION}_en-US.exe

wget -O torbrowser-install-${TOR_VERSION}_zh-CN.exe https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/torbrowser-install-${TOR_VERSION}_zh-CN.exe
wget -O torbrowser-install-win64-${TOR_VERSION}_zh-CN.exe https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/torbrowser-install-win64-${TOR_VERSION}_zh-CN.exe

wget -O TorBrowser-${TOR_VERSION}-osx64_en-US.dmg https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/TorBrowser-${TOR_VERSION}-osx64_en-US.dmg
wget -O TorBrowser-${TOR_VERSION}-osx64_zh-CN.dmg https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/TorBrowser-${TOR_VERSION}-osx64_zh-CN.dmg

wget -O tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz

tar -czvf browser.tar.gz ./*