#!/bin/bash
read -p "please input GIT Work Path:(/git/work_path) " GIT_WORK
read -p "please input GIT Storage Name:(ProjectName) " GIT_NAME

if [ ! `grep -Eq "^git" /etc/group` ]; then
	groupadd -r git
fi

if [ ! `grep -Eq "^git" /etc/passwd` ]; then
	useradd -r -g git -d /home/git -m git
fi

if [ ! -e /home/git/.ssh ]; then
	mkdir /home/git/.ssh	
fi

function set_ssh_secret() {
	read -p "please input SSH Secret: " SSH_SECRET
	echo "${SSH_SECRET}" > /homt/git/.ssh/authorized_keys

	chmod 755 /home/git
	chmod 700 /home/git/.ssh
	chmod 600 /home/git/.ssh/authorized_keys
	chown -R git:git /home/git
}


if [ !  -e ${GIT_WORK} ]; then
	mkdir -p ${GIT_WORK}
fi

cd ${GIT_WORK}
if [ ! -e ${GIT_NAME}.git ]; then
	\rm -rf ${GIT_NAME}.git
fi
git init --bare ${GIT_NAME}.git


chown -R git:git ${GIT_WORK}
chmod 755 ${GIT_WORK}

echo "git auto web deploy success!"
echo "git remote add develop ssh://git@ipaddr:22${GIT_WORK}/${GIT_NAME}.git"