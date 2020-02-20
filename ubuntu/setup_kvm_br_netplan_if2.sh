#!/bin/bash
IF_MGMT="enp1s0"
IF_LOCAL="enp2s0"

IP_MGMT=$(ifconfig $IF_MGMT | grep -Po 'inet \K[\d.]+')
IP_MGMT_GW="10.158.57.1"
IP_LOCAL=$(ifconfig $IF_LOCAL | grep -Po 'inet \K[\d.]+')

NETPLAN_CFG_FL="/etc/netplan/01-netcfg.yaml"

cat >$NETPLAN_CFG_FL << EOL
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets: 
    $IF_MGMT:
      dhcp4: no
    $IF_LOCAL:
      dhcp4: no

  bridges:  
    br-mgmt:   
      dhcp4: no  
      interfaces: 
        - $IF_MGMT  
      addresses: [$IP_MGMT/24]
      gateway4: $IP_MGMT_GW
      nameservers:  
        addresses: [10.32.1.7, 8.8.8.8]
    br-local:
      dhcp4: no  
      interfaces:  
        - $IF_LOCAL 
      addresses: [$IP_LOCAL/24]
EOL

echo "-- NETPLAN CONFIG:\n"
cat $NETPLAN_CFG_FL
