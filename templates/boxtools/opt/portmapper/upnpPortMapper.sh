#!/bin/bash
#~/bin/upnpPortMapper.sh
#sudo apt-get install miniupnpc
#crontab -l | grep upnp || echo $(crontab -l ; echo '*/5 * * * * ~/bin/upnpPortMapper.sh  >/dev/null 2>&1') | crontab -

export LC_ALL=C
router=$(ip r | grep default | cut -d " " -f 3)
gateway=$(upnpc -l | grep "desc: http://$router:[0-9]*/rootDesc.xml" | cut -d " " -f 3)
ip=$(upnpc -l | grep "Local LAN ip address" | cut -d: -f2)

external=80
port=80
upnpc -u  $gateway -d $external TCP
upnpc -u  $gateway -e "Web mapping for Server" -a $ip $port $external TCP 

external=443
port=443
upnpc -u  $gateway -d $external TCP
upnpc -u  $gateway -d $external UDP
upnpc -u  $gateway -e "HTTPS Web mapping for server" -a $ip $port $external TCP 
