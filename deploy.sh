#!/bin/bash
# This scirpt is made by Pete.
# It is used for deploy new code to EVE-NG Community 203.110 platform
# DO NOT USE IT ON ANY OTHER VERSION OF EVE-NG
# Email pete19890813@gmail.com
# Feel free to contact me if you have any problem.


ciscokeygen='/opt/unetlab/scripts/CiscoKeyGen.py'

user=$(whoami)

if [ "$user" != "root" ]; then
	echo '[!] Current user not root, please change user as root to exceute this script.'
	exit 1
fi

sudo dpkg -l | grep eve > /dev/null
if [ $? -ne 0 ]; then
	echo '[!] eve-ng is not installed on current system, exit.'
	exit 1
fi

if [ -d ./html ] && [ -d /opt/unetlab ]; then
	cp -r ./html /opt/unetlab
	if [ $? -ne 0 ]; then
		echo '[-] Copy folder "html" to "/opt/unetlab" failed'
		htmlcp='failed'
	else
		echo '[+] Copy folder "html" to "/opt/unetlab" success!'
	fi
fi

if [ -d ./wrappers ] && [ -d /opt/unetlab ]; then
	cp -r ./wrappers /opt/unetlab
	if [ $? -ne 0 ]; then
		echo '[-] Copy folder "wrappers" to "/opt/unetlab" failed'
		wrappers='failed'
	else
		echo '[+] Copy folder "wrappers" to "/opt/unetlab" success!'
	fi
fi

if [ -d ./scripts ] && [ -d /opt/unetlab ]; then
	cp -r ./scripts /opt/unetlab
	if [ $? -ne 0 ]; then
		echo '[-] Copy folder "scripts" to "/opt/unetlab" failed'
		scrptscp='failed'
	else
		echo '[+] Copy folder "scripts" to "/opt/unetlab" success!'
	fi
fi

grep -P 'www-data.*ALL=' /etc/sudoers > /dev/null
if [ $? -ne 0 ]; then
	sed -i 's#root\t\+.\+ALL$#&\nwww-data ALL=(ALL:ALL) NOPASSWD:ALL#' /etc/sudoers
	grep -P '^root\t+ALL=' /etc/sudoers > /dev/null
	if [ $? -ne 0 ]; then
		echo '[-] Add user www-data to sudoers failed'
		sudoers='failed'
	else
		echo '[+] Add user www-data to sudoers success!'
	fi
else
	echo '[-] User www-data is alreay in sudoers!'
fi

if [ ! -x $ciscokeygen ]; then
	chmod +x $ciscokeygen
	if [ $? -ne 0 ]; then
		echo '[-] Change CiscoKeygen.py to excutable failed.'
	else
		echo '[+] Change CiscokeyGen.py to excuteable success!'
		ln -s $ciscokeygen /usr/bin/CiscoKeyGen
	fi		
fi

if [ "$wrappers" != "failed" ]; then
	sudo /opt/unetlab/wrappers/unl_wrapper -exia fixpermissions
	if [ $? -ne 0 ]; then
		echo '[-] fix permissions failed.'
		exit 1
	else
		echo '[+] fix permissions success!'
	fi
fi

cat > /etc/rc.local <<EOF
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.


/usr/local/sbin/dkms_install_fastlinq.sh

checkpnetnat=$(ip link | grep pnet1)
if [[ "$checkpnetnat" = "" ]]; then
    brctl addbr pnet1;
fi
ip link set dev pnet1 up
ip addr add 10.0.137.1/24 dev pnet1 > /dev/null 2>&1
pkill dnsmasq
dnsmasq --interface=pnet1 --dhcp-range=10.0.137.10,10.0.137.254,255.255.255.0 --dhcp-option=3,10.0.137.1 &
iptables -t nat -D POSTROUTING -o pnet0 -s 10.0.137.1/24 -j MASQUERADE > /dev/null 2>&1
iptables -t nat -A POSTROUTING -o pnet0 -s 10.0.137.1/24 -j MASQUERADE

exit 0
EOF

exit 0 
