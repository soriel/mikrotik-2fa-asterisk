## Create log and log action
/system logging action add memory-lines=2000 name=2fa target=memory
/system logging add action=2fa topics=radius
## Reset error.html
/ip proxy reset-html
## Create firewall rules
/ip firewall filter add action=accept chain=input comment="Allow 2fa for vpnblacked" dst-port=8080 protocol=tcp src-address-list=vpnblocked
/ip firewall filter add action=reject chain=forward comment="Deny 2fa for vpnblacked" reject-with=icmp-admin-prohibited src-address-list=vpnblocked
/ip firewall filter add action=reject chain=input comment="Deny 2fa for vpnblacked" reject-with=icmp-admin-prohibited src-address-list=vpnblocked
/ip firewall nat add action=redirect chain=dstnat comment="Redirect to web-proxy for vpnblocked" dst-port=80 protocol=tcp src-address-list=vpnblocked to-ports=8080
## Confirure web proxy
/ip proxy set cache-administrator=admin@example.com enabled=yes
/ip proxy access add action=deny
## Create profile for 2fa
/ppp profile add name=2fa on-down="/ip firewall address-list remove numbers=[find where comment~\$user list=vpnblocked]\r\
    \n\r\
    \n:local callerId\r\r\
    \n:local calledId\r\r\
    \n:set callerId \$\"caller-id\"\r\r\
    \n:set calledId \$\"called-id\"\r\r\
    \n:local datetime [/system clock get date]\r\r\
    \n:local time [/system clock get time]\r\r\
    \n/log info \"VPN-con \$datetime \$time Disconnected user: \$user \$callerId\"" on-up=":local datetime [/system clock get date]\r\
    \n:local time [/system clock get time]\r\
    \n:local remoteAddr\r\
    \n:local callerid\r\
    \n:set remoteAddr \$\"remote-address\"\r\
    \n:set callerid \$\"caller-id\"\r\
    \n:local 2facomment; \r\
    \n\r\
    \n:foreach line in=[/log find buffer=2fa (message~\"MT-Wireless-Comment =\")] do={\
    \n \r\
    \n  :do {:local content [/log get \$line message];\
    \n  #:put \$content;\
    \n  #:put [:len \$content];\
    \n  :local pos1add [:find \$content \" = \" 0];\
    \n  :if ([:len \$pos1add] != 0) do={ \
    \n    #:put \$pos1add;\
    \n    :local pos2add [:len \$content];\
    \n    #:put \$pos2add;\
    \n    #:global 2facomment; \
    \n    if ([:len \$pos2add] != 0) do={  \
    \n      :set 2facomment [:pick \$content (\$pos1add+4) (\$pos2add-1)];\
    \n      #:put \"\$2facomment\";\
    \n      };\
    \n   };\
    \n };\
    \n if ($2facomment ~ $user) do={
    \n    delay 2;
    \n     /ip firewall address-list add address=$remoteAddr list=vpnblocked timeout=200d comment=$"2facomment"
    \n     /log info "VPN-con $datetime $time Connected user: $"2facomment" $"caller-id" $"remote-address""
    \n  };\r\
    \n};\r\
    \n\r\
    \ndelay 2;\r\
    \n#/ip firewall address-list remove numbers=[find where comment=\$2facomment list=vpnblocked]\r\
    \n#/ip firewall address-list add address=\$remoteAddr list=vpnblocked timeout=200d comment=\$\"2facomment\"\r\
    \n#/log info \"VPN-con \$datetime \$time Connected user: \$\"2facomment\" \$\"caller-id\" \$\"remote-address\"\"" only-one=yes use-encryption=yes

