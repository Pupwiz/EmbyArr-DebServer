#!/bin/bash
stat -c %s
DIR=$(pwd)
rm $DIR/local_packages/prowlarr*.deb
mkdir -p $DIR/prowlarr_amd64/opt
wget --content-disposition "https://prowlarr.servarr.com/v1/update/develop/updatefile?os=linux&runtime=netcore&arch=x64"
tar xfz Prowlarr.*.*.linux-core-x64.tar.gz -C $DIR/prowlarr_amd64/opt
VER=$(find ./Prowlarr*  -name '*.tar.gz'|grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
rm Prowlarr.*.*.linux-core-x64.tar.gz
cp $DIR/templates/prowlarr/. $DIR/prowlarr_amd64/ -r
sed -i.bak "/^[[:space:]]*Version:/ s/:.*/: $VER/" $DIR/prowlarr_amd64/DEBIAN/control
chown -R media: $DIR/prowlarr_amd64/home $DIR/prowlarr_amd64/opt
dpkg-deb -b prowlarr_amd64/ prowlarr_$VER-amd64.deb
mv prowlarr_$VER-amd64.deb ./local_packages
rm $DIR/prowlarr_amd64/ -r
