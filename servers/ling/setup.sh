#!/bin/sh

log () {
	printf '\033[35m%s\033[0m\n' "$*"
}

committee () {
	log Adding committee user: $1
	useradd -m -s /bin/zsh -G committee $1
	mkdir /home/$1/.ssh
	log Please enter SSH public key for $1 and then hit ^D:
	cat > /home/$1/.ssh/authorized_keys
}

log Adding user group: committee
groupadd committee

log Allowing members of commitee to sudo without password
echo '%committee ALL = NOPASSWD: ALL' > /etc/sudoers.d/committee

log Setting root shell to /bin/false to discourage shell usage
chsh -s /bin/false < /dev/null

log Deleting authorized_keys to prevent root SSH usage
rm .ssh/authorized_keys

log Updating package lists

log Installing packages
apt-get -qq install zsh mosh jekyll nginx > /dev/null

committee delan

log Setup complete
