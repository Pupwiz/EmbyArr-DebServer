#!/bin/bash
DIR=$(pwd)
#sonarr=3.0.9.1555
#rm $DIR/local_packages/sonarr*.deb
mkdir -p $DIR/sonarr_amd64/opt
mkdir -p $DIR/sonarr_amd64/tmp
cd $DIR/sonarr_amd64/tmp
wget -O sonarr.tar.gz "https://services.sonarr.tv/v1/download/develop/latest?version=3&os=linux"
tar xvf sonarr.tar.gz -C $DIR/sonarr_amd64/opt
sonarr=$(awk -F= '/ReleaseVersion=/{print $2; exit}' $DIR/sonarr_amd64/opt/Sonarr/release_info)
cd $DIR
rm $DIR/sonarr_amd64/tmp -r
cp $DIR/templates/sonarr/. $DIR/sonarr_amd64/ -r
sed -i.bak "/^[[:space:]]*Version:/ s/:.*/: ${sonarr}/" $DIR/sonarr_amd64/DEBIAN/control 
chown -R media: $DIR/sonarr_amd64/home $DIR/sonarr_amd64/opt
dpkg-deb -b sonarr_amd64/ sonarr_${sonarr}-amd64.deb
mv sonarr_${sonarr}-amd64.deb $DIR/local_packages 
rm sonarr_amd64/ -r
exit 0

