#!/bin/bash
sudo usermod -s /bin/bash -aG sudo media
sudo usermod -s /bin/bash emby
sudo usermod -a -G media emby
sudo usermod -a -G emby media
systemctl enable emby-server
apt -qq install -y nodejs || exit 1
pip install bottle --break-system-packages || exit 1
pip install swig --break-system-packages || exit 1
pip install -r /opt/mp4auto/setup/requirements.txt --break-system-packages || exit 1
pip install ytdl-sub --break-system-packages || exit 1
echo "Getting Things Ready Please Wait..!" | wall -n
echo "Installer adding final programs..!" | wall -n
echo "Installing Nodejs and NPM..!" | wall -n
chown media: -R /opt/mp4auto || exit 1
echo "Installing Cloudcmd with Gritty..!"  | wall -n
sudo -H -E npm install cloudcmd -g
sudo -H -E npm install gritty -g
cat >"/etc/systemd/system/cloudcmd.service" <<SER
[Unit]
        Description=Cloud Commander
        [Service]
        TimeoutStartSec=0
        Restart=always
        User=root
        WorkingDirectory=/home/media
        ExecStart=/usr/bin/cloudcmd
        [Install]
        WantedBy=multi-user.target
SER
echo "Starting Cloudcmd..!"  | wall -n
# Reload systemd daemon
systemctl daemon-reload
# Enable the service for following restarts
systemctl enable cloudcmd.service
# Run the service
systemctl start cloudcmd.service
echo "Installing Sickbeard MP4 automation..!"  | wall -n
pip install -r /opt/mp4auto/setup/requirements.txt --break-system-packages || exit 1
chown media: -R /opt/mp4auto || exit 1
echo "Installing Flaresolverr requirements"
pip install -r /opt/requirements.txt --break-system-packages || exit 1
echo "System will reboot one last time for final updates install..!"  | wall -n
echo "Updates and software not required to make the system run will "  | wall -n
echo "now be removed please wait for the reboot. Dont force the system off..!"  | wall -n
sudo apt upgrade -qq -y
DEBIAN_FRONTEND=noninteractive apt-get -qq remove debian-faq debian-faq-de debian-faq-fr debian-faq-it debian-faq-zh-cn  doc-debian foomatic-filters hplip iamerican ibritish ispell vim-common vim-tiny reportbug laptop-detect
sudo apt autoremove -qq -y
echo "Cleanup done adding tailscale for remote assitance..!"  | wall -n
## Remove stock bootup info and replace with custom
rm /etc/issue
cat > /etc/issue << EOF
Hostname \n
Date: \d
IP4 address: \4
Login User: \U
\t
Welcome!
EOF
##Get localhost ip and add it to organizer database
IFACE=$(ip route get 8.8.8.8 | awk -- '{printf $5}')
NETIP=$(ip a s $IFACE | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2)
cat > /tmp/org.sql << ORG
 UPDATE tabs SET url = REPLACE(url,'http://127.0.0.1', 'http://$NETIP');
 UPDATE tabs SET url_local = REPLACE(url_local,'http://127.0.0.1', 'http://$NETIP');
ORG
cat /tmp/org.sql | sqlite3 /var/www/html/data/orgdb.db
rm /tmp/org.sql
#Find and update API keys for prowlarr sync 1st pass
/bin/bash /home/media/update_arr.database || exit 1
## Add cron to capture slow apps api key gen note seems to have fixed in arr updates 
#crontab -r
#(crontab -u root -l ; echo "@reboot /home/media/lateradarrkey.database ") | crontab -u root -
#(crontab -u root -l ; echo "*/2 * * * * /home/media/lateradarrkey.database ") | crontab -u root -
##Remove the root user boot override 
rm /etc/systemd/system/getty@.service.d/override.conf
## live enable tailscale to my account
## using tailscale to connect server to tail scale account and provide remote assit.
# sudo tailscale up -authkey your key here -ssh
##Ensure www-data owns html folder for web access 
sudo chown -R www-data:www-data /var/www/html
rm -- "$0"
echo "Rebooting Thanks for your patience..!"  | wall -n
init 6
exit 0
