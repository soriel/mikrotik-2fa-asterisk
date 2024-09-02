/usr/local/bin/2factor-mikrotik.sh 
#!/bin/bash
/usr/bin/ssh -oStrictHostKeyChecking=no asterisk@192.168.88.1 "/ip firewall address-list remove numbers=[find where comment~\"$1\" list=vpnblocked]
