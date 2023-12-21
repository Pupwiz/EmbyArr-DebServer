#!/bin/bash
DIR=$(pwd)
sabnzbdfile="$(
curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest \
| grep browser_download_url | grep 'tar[.]gz' | head -n 1 | cut -d '"' -f 4 \
)"
mkdir -p $DIR/sabnzbd_amd64/opt
mkdir -p $DIR/sabnzbd_amd64/tmp
cd $DIR/sabnzbd_amd64/tmp
wget -O sabnzbd.tar.gz "$sabnzbdfile"
tar xvf sabnzbd.tar.gz -C $DIR/sabnzbd_amd64/opt
mv $DIR/sabnzbd_amd64/opt/SABnzbd* $DIR/sabnzbd_amd64/opt/sabnzbd
cd $DIR
rm $DIR/sabnzbd_amd64/tmp -r
cp $DIR/templates/sabnzbd/. $DIR/sabnzbd_amd64/ -r
chown -R media: $DIR/sabnzbd_amd64/opt
dpkg-deb -b sabnzbd_amd64/ sabnzbd_4.1.0-amd64.deb
mv $DIR/sabnzbd_4.1.0-amd64.deb $DIR/local_packages 
rm sabnzbd_amd64/ -r
exit 0

