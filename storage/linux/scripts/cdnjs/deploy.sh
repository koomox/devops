#!/bin/bash
cdnjs=/var/www/cdnjs/ajax/libs
jquery_version_3x=3.4.1
jquery_version_2x=2.2.4
jquery_version_1x=1.12.4
bootstrap_version=4.4.1
fontawesome_version=4.7.0

mkdir -p $cdnjs/jquery/{$jquery_version_3x,$jquery_version_2x,$jquery_version_1x} $cdnjs/{bootstrap,font-awesome}

wget -O ${cdnjs}/jquery/${jquery_version_3x}/jquery.min.js https://code.jquery.com/jquery-${jquery_version_3x}.min.js
wget -O ${cdnjs}/jquery/${jquery_version_3x}/jquery.js https://code.jquery.com/jquery-${jquery_version_3x}.js
wget -O ${cdnjs}/jquery/${jquery_version_3x}/jquery.min.map https://code.jquery.com/jquery-${jquery_version_3x}.min.map

wget -O ${cdnjs}/jquery/${jquery_version_3x}/jquery.slim.min.js https://code.jquery.com/jquery-${jquery_version_3x}.slim.min.js
wget -O ${cdnjs}/jquery/${jquery_version_3x}/jquery.slim.js https://code.jquery.com/jquery-${jquery_version_3x}.slim.js
wget -O ${cdnjs}/jquery/${jquery_version_3x}/jquery.slim.min.map https://code.jquery.com/jquery-${jquery_version_3x}.slim.min.map

wget -O ${cdnjs}/jquery/${jquery_version_2x}/jquery.js https://code.jquery.com/jquery-${jquery_version_2x}.js
wget -O ${cdnjs}/jquery/${jquery_version_2x}/jquery.min.js https://code.jquery.com/jquery-${jquery_version_2x}.min.js

wget -O ${cdnjs}/jquery/${jquery_version_1x}/jquery.js https://code.jquery.com/jquery-${jquery_version_1x}.js
wget -O ${cdnjs}/jquery/${jquery_version_1x}/jquery.min.js https://code.jquery.com/jquery-${jquery_version_1x}.min.js

wget -O /tmp/bootstrap-${bootstrap_version}-dist.zip https://github.com/twbs/bootstrap/releases/download/v${bootstrap_version}/bootstrap-${bootstrap_version}-dist.zip
unzip -d ${cdnjs}/bootstrap /tmp/bootstrap-${bootstrap_version}-dist.zip
mv ${cdnjs}/bootstrap/bootstrap-${bootstrap_version}-dist ${cdnjs}/bootstrap/${bootstrap_version}

wget -O /tmp/font-awesome-${fontawesome_version}.zip https://fontawesome.com/v${fontawesome_version}/assets/font-awesome-${fontawesome_version}.zip
unzip -d ${cdnjs}/font-awesome /tmp/font-awesome-${fontawesome_version}.zip
mv ${cdnjs}/font-awesome/font-awesome-${fontawesome_version} ${cdnjs}/font-awesome/${fontawesome_version}