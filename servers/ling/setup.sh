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

log Configuring Hurricane Electric IPv6 tunnel
echo >> /etc/network/interfaces
echo 'auto he-ipv6' >> /etc/network/interfaces
echo 'iface he-ipv6 inet6 v4tunnel' >> /etc/network/interfaces
echo 'address 2001:db8:0f10:99d::2' >> /etc/network/interfaces
echo 'netmask 64' >> /etc/network/interfaces
echo 'endpoint 209.51.181.2' >> /etc/network/interfaces
echo 'ttl 255' >> /etc/network/interfaces
echo 'gateway 2001:db8:0f10:99d::1' >> /etc/network/interfaces
echo >> /etc/network/interfaces
ifup he-ipv6
ping6 -c1 google.com > /dev/null

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
