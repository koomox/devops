#!/bin/bash
DATETIME=$(date +%Y%m%d)
\rm -rf ./teamviewer
mkdir -p ./teamviewer
cd ./teamviewer

wget -O TeamViewerQS_${DATETIME}.exe https://download.teamviewer.com/download/TeamViewerQS.exe
wget -O TeamViewer_Host_Setup_${DATETIME}.exe https://download.teamviewer.com/download/TeamViewer_Host_Setup.exe
wget -O TeamViewerPortable_${DATETIME}.zip https://download.teamviewer.com/download/TeamViewerPortable.zip

wget -O TeamViewerQS_${DATETIME}.dmg https://download.teamviewer.com/download/TeamViewerQS.dmg
wget -O TeamViewerHost_${DATETIME}.dmg https://download.teamviewer.com/download/TeamViewerHost.dmg
wget -O TeamViewer_${DATETIME}.dmg https://download.teamviewer.com/download/TeamViewer.dmg

wget -O teamviewer_qs_${DATETIME}.tar.gz https://download.teamviewer.com/download/teamviewer_qs.tar.gz
wget -O teamviewer-host_amd64_${DATETIME}.deb https://download.teamviewer.com/download/linux/teamviewer-host_amd64.deb
wget -O teamviewer_amd64_${DATETIME}.deb https://download.teamviewer.com/download/linux/teamviewer_amd64.deb

tar -czvf TeamViewer_${DATETIME}.tar.gz ./*