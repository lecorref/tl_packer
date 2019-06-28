#!/bin/bash

# This create the /etc/hosts file
#

cat <<EOF > /etc/hosts
127.0.0.1       localhost
193.48.235.$TAG_VLAN   $HOSTNAME.tl.teralab-datascience.fr $HOSTNAME

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

# This put the hostname at the right places
#

echo "$HOSTNAME" > /etc/hostname 

# Modify the /etc/network/interfaces
#


cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

# Interface sur INTERNET
allow-hotplug eth0
iface eth0 inet static
        address 193.48.235.$TAG_VLAN
        netmask 255.255.255.0
        network 193.48.235.0
        broadcast 193.48.235.255
        gateway 193.48.235.1

# Interface sur SLAPOSCOM
auto eth1
iface eth1 inet static
        address 192.168.218.$TAG_VLAN
        netmask 255.255.255.0
        network 192.168.218.0
        broadcast 192.168.218.255
        up route add -net 10.32.0.0/13 gw 192.168.218.218

# Interface sur INTERCO
auto eth2
iface eth2 inet static
        address 192.168.200.$TAG_VLAN
        netmask 255.255.255.0
        network 192.168.200.0
        broadcast 192.168.200.255
        up route add -net 10.200.201.0 netmask 255.255.255.0 gw 192.168.200.201
        up route add -net 10.200.198.0 netmask 255.255.255.0 gw 192.168.200.201
        dns-nameservers 10.200.198.13
        dns-search tl.teralab-datascience.fr

# Interface sur VLAN
auto eth3
iface eth3 inet static
        address 10.200.$TAG_VLAN.1
        netmask 255.255.255.0
        network 10.200.$TAG_VLAN.0
        broadcast 10.200.$TAG_VLAN.255
EOF
