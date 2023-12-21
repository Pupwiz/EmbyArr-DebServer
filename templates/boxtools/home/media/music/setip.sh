#!/bin/bash
## The following script changes templates in the system to match your LAN ip 
## for proper redirects to you mediabox server. If something seems to have failed 
## redirecting try running this to fix the ip's espacially if have not set the router
## to lock the server IP to prevent changes on router reboots / hydro outages...
## the script is set to check the IP at boot and update as required. 
IP=`ip addr show |grep "inet " |grep -v 127.0.0. |head -1|cut -d" " -f6|cut -d/ -f1` 
if [ "$IP" = "" ]; then 
   exit
else
sed -i -e "/.*:9091/s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$IP/g" /etc/nginx/sites-available/default
sed -i -e "/.*:8000/s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$IP/g" /etc/nginx/apps/cloudcmd.tmpl
#sed -i -e "/.*:9090/s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$IP/g" /etc/nginx/apps/glances.tmpl
sed -i -e "/.*:7878/s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$IP/g" /etc/nginx/apps/radarr.tmpl
sed -i -e "/.*:8686/s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$IP/g" /etc/nginx/apps/lidarr.tmpl
sed -i -e "/.*:9696/s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$IP/g" /etc/nginx/apps/prowlarr.tmpl
fi
exit
##installed php version check 
# echo "$(ls /lib/systemd/system | grep php | grep fpm | sort | tail -1 | grep -o -P '(?<=php).*(?=-fpm)')"
# Get routing IP for scripts router=`ip route get 8.8.8.8 | awk '{print $3}'`
# Get network device dev=`ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//"`
# Get lan IP for scripts GATEWAYIP=$(ip address show ens18 | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' | egrep -v '255|(127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' | tail -n1)