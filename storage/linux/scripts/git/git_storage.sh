#!/bin/bash
read -p "please input GIT Work Path:(/git/work_path) " GIT_WORK
read -p "please input GIT Storage Name:(ProjectName) " GIT_NAME

function git_user() {
	grep -E "^git" /etc/group >& /dev/null
	if [ $? -ne 0 ]; then
		groupadd -r git
	fi

	grep -E "^git" /etc/passwd >& /dev/null
	if [ $? -ne 0 ]; then
		useradd -r -g git -d /home/git -m git
	fi

	if [ ! -e /home/git/.ssh ]; then
		mkdir /home/git/.ssh	
	fi
}

function git_private() {
	if [ ! -e /homt/git/.ssh/authorized_keys ] || [ ! -s /homt/git/.ssh/authorized_keys ]; then
		set_ssh_secret
	fi
}

function set_ssh_secret() {
	read -p "please input SSH Secret: " SSH_SECRET
	echo "${SSH_SECRET}" > /homt/git/.ssh/authorized_keys

	chmod 755 /home/git
	chmod 700 /home/git/.ssh
	chmod 600 /home/git/.ssh/authorized_keys
	chown -R git:git /home/git
}

git_user
git_private

if [ !  -e ${GIT_WORK} ]; then
	mkdir -p ${GIT_WORK}
fi

cd ${GIT_WORK}
if [ -e ${GIT_NAME}.git ]; then
	\rm -rf ${GIT_NAME}.git
fi
git init --bare ${GIT_NAME}.git


chown -R git:git ${GIT_WORK}
chmod 755 ${GIT_WORK}

echo "git storage create success!"
echo "git remote add develop ssh://git@ipaddr:22${GIT_WORK}/${GIT_NAME}.git"