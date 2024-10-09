#!/bin/bash
read -p "please input GIT Work Path:(/git/work_path) " GIT_WORK
read -p "please input GIT Storage Name:(ProjectName) " GIT_NAME
read -p "please input WEB Work Path:(/web/work_path) " WEB_WORK

function create_system_user() {
	USERNAME=$1
	if ! `grep -Eq "^${USERNAME}" /etc/group` ; then
		groupadd -r ${USERNAME}
	else
		echo "${USERNAME} Group Already Exist!"
	fi

	if ! `grep -Eq "^${USERNAME}" /etc/passwd` ; then
		useradd -r -g ${USERNAME} -d /home/${USERNAME} -m ${USERNAME}
	else
		echo "User ${USERNAME} Already Exist!"
	fi

	if [ ! -e /home/${USERNAME}/.ssh ]; then
		mkdir -p /home/${USERNAME}/.ssh
	fi
}

function git_private() {
	if [ ! -e /home/git/.ssh/authorized_keys ] || [ ! -s /home/git/.ssh/authorized_keys ]; then
		set_ssh_secret
	fi
}

function set_ssh_secret() {
	read -p "please input SSH Secret: " SSH_SECRET
	echo "${SSH_SECRET}" > /home/git/.ssh/authorized_keys

	chmod 755 /home/git
	chmod 700 /home/git/.ssh
	chmod 600 /home/git/.ssh/authorized_keys
	chown -R git:git /home/git
}

create_system_user git
git_private


if [ !  -e ${GIT_WORK} ]; then
	mkdir -p ${GIT_WORK}
fi

cd ${GIT_WORK}
if [ -e ${GIT_NAME}.git ]; then
	\rm -rf ${GIT_NAME}.git
fi
git init --bare ${GIT_NAME}.git

if [ -e ${WEB_WORK} ]; then
	\rm -rf ${WEB_WORK}
fi
mkdir -p ${WEB_WORK}

touch ${GIT_WORK}/${GIT_NAME}.git/hooks/post-receive
chmod +x ${GIT_WORK}/${GIT_NAME}.git/hooks/post-receive
cat > ${GIT_WORK}/${GIT_NAME}.git/hooks/post-receive << EOF
#!/bin/bash
echo "Running Post Receive Hook"

export GIT_WORK_TREE=${WEB_WORK}
export GIT_DIR=${GIT_WORK}/repo.git
cd \${GIT_WORK_TREE}
git reset --hard master
EOF

chown -R git:git ${GIT_WORK} ${WEB_WORK}
chmod 755 ${GIT_WORK} ${WEB_WORK}

echo "git auto web deploy success!"
echo "git remote add develop ssh://git@ipaddr:22${GIT_WORK}/${GIT_NAME}.git"