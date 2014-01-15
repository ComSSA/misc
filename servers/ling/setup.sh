#!/bin/sh

set -e

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

package () {
	log Installing package: $1
	apt-get -qq install $1 > /dev/null
}

log Adding user group: committee
groupadd committee

log Allowing members of commitee to sudo without password
echo '%committee ALL = NOPASSWD: ALL' > /etc/sudoers.d/committee

log Setting root shell to /bin/false to discourage shell usage
chsh -s /bin/false < /dev/null # fail if interactive password requested

log Deleting authorized_keys to prevent root SSH usage
rm .ssh/authorized_keys

log Updating package lists
apt-get -qq update

package zsh
package mosh
package nginx
package screen
package ruby-dev
package python-dev
package build-essential
package python-virtualenv

log Installing Jekyll
gem install jekyll > /dev/null

committee delan

log Setup complete
