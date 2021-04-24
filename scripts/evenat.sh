#!/bin/bash
checkpnetnat=$(ip link | grep nat)
if [[ "$checkpnetnat" = "" ]]; then
    brctl addbr nat;
fi
ip link set dev nat up
ip addr add 10.0.137.1/24 dev nat > /dev/null 2>&1
pkill dnsmasq
dnsmasq --interface=nat --dhcp-range=10.0.137.10,10.0.137.254,255.255.255.0 --dhcp-option=3,10.0.137.1 &
iptables -t nat -D POSTROUTING -o pnet0 -s 10.0.137.1/24 -j MASQUERADE > /dev/null 2>&1
iptables -t nat -A POSTROUTING -o pnet0 -s 10.0.137.1/24 -j MASQUERADE

ntpdate -u ntp.ubuntu.com

