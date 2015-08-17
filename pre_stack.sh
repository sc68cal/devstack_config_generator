#!/bin/sh

## Turn on IPv6 
sudo echo "ipv6" >> /etc/modprobe
sudo modprobe ipv6

## Ubuntu 12.04 ships with a very old version of OVS,
## so add the cloud-archive (https://wiki.ubuntu.com/ServerTeam/CloudArchive)
## and install a more recent version
sudo apt-get update
sudo apt-get install -y python-software-properties
sudo add-apt-repository cloud-archive:havana
sudo apt-get update
sudo apt-get install -y openvswitch-switch
sudo apt-get install python-dev

cat >> /etc/network/interfaces <<EOF
auto eth1
iface eth1 inet manual
	up ifconfig $IFACE 0.0.0.0 up
	down ifconfig $IFACE 0.0.0.0 down
EOF
