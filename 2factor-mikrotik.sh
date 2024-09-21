#!/bin/sh
# copy this to /usr/local/bin/2factor-mikrotik.sh 
MIKROTIK_IP="192.168.88.1"
/usr/bin/ssh -oStrictHostKeyChecking=no asterisk@${MIKROTIK_IP} "/ip firewall address-list remove numbers=[find where comment~\"$1\" list=vpnblocked]"
