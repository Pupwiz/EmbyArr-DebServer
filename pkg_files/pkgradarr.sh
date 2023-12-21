#!/bin/bash
stat -c %s
DIR=$(pwd)
rm $DIR/local_packages/radarr*.deb
mkdir -p $DIR/radarr_amd64/opt
wget --content-disposition 'https://radarr.servarr.com/v1/update/develop/updatefile?os=linux&runtime=netcore&arch=x64'
tar xfz Radarr.*.*.linux-core-x64.tar.gz -C $DIR/radarr_amd64/opt
VER=$(find ./Radarr*  -name '*.tar.gz'|grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
rm Radarr.*.*.linux-core-x64.tar.gz
cp $DIR/templates/radarr/. $DIR/radarr_amd64/ -r
sed -i.bak "/^[[:space:]]*Version:/ s/:.*/: $VER/" $DIR/radarr_amd64/DEBIAN/control
chown -R media: $DIR/radarr_amd64/home $DIR/radarr_amd64/opt
dpkg-deb -b radarr_amd64/ radarr_$VER-amd64.deb
mv radarr_$VER-amd64.deb ./local_packages
rm $DIR/radarr_amd64/ -r
