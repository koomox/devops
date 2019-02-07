#!/bin/bash
read -p "please input GIT Work Path:(/git/work_path) " GIT_WORK
read -p "please input WEB Work Path:(/web/work_path) " WEB_WORK

if [ ! `grep -Eq "^git" /etc/group` ]; then
	groupadd -r git
fi

if [ ! `grep -Eq "^git" /etc/passwd` ]; then
	useradd -r -g git -d /home/git -m git
fi

if [ ! -e /home/git/.ssh ]; then
	mkdir /home/git/.ssh	
fi

read -p "please input SSH Secret: " SSH_SECRET
echo "${SSH_SECRET}" > /homt/git/.ssh/authorized_keys

chmod 755 /home/git
chmod 700 /home/git/.ssh
chmod 600 /home/git/.ssh/authorized_keys
chown -R git:git /home/git


if [ -e ${GIT_WORK} ]; then
	\rm -rf ${GIT_WORK}
fi
if [ -e ${WEB_WORK} ]; then
	\rm -rf ${WEB_WORK}
fi
mkdir -p ${WEB_WORK} ${GIT_WORK}

cd ${GIT_WORK}
git init --bare repo.git

touch ${GIT_WORK}/repo.git/hooks/post-receive
chmod +x ${GIT_WORK}/repo.git/hooks/post-receive
cat > ${GIT_WORK}/repo.git/hooks/post-receive << EOF
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
echo "git remote add develop ssh://git@ipaddr:22${GIT_WORK}/repo.git"