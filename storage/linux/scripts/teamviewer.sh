#!/bin/bash
\rm -rf /opt/teamviewer
mkdir -p /opt/teamviewer
cd /opt/teamviewer

wget https://download.teamviewer.com/download/TeamViewerQS.exe
wget https://download.teamviewer.com/download/TeamViewer_Host_Setup.exe
wget https://download.teamviewer.com/download/TeamViewerPortable.zip

wget https://download.teamviewer.com/download/TeamViewerQS.dmg
wget https://download.teamviewer.com/download/TeamViewerHost.dmg
wget https://download.teamviewer.com/download/TeamViewer.dmg

wget https://download.teamviewer.com/download/TeamViewerQS.apk
wget https://download.teamviewer.com/download/TeamViewerHost.apk
wget https://download.teamviewer.com/download/TeamViewer.apk

tar -czvf TeamViewer.tar.gz ./*