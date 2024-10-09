#!/bin/bash
WORK_PATH=/tmp/make_phpfpm
mkdir -p ${WORK_PATH}
cd ${WORK_PATH}
\rm -rf *

curl -LO https://secure.php.net/distributions/php-7.3.0.tar.xz
xz -d php-7.3.0.tar.xz
tar -xf php-7.3.0.tar

cd php-7.3.0
