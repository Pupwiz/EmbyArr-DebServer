#!/bin/bash
VER=1.06
DIR=$(pwd)
rm $DIR/local_packages/boxtools*.deb
mkdir -p $DIR/boxtools_amd64/opt
cd $DIR/boxtools_amd64/opt
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git mp4auto
git clone https://github.com/Pupwiz/Scripts.git bt_scripts
mkdir -p blocklists
wget https://raw.githubusercontent.com/Naunter/BT_BlockLists/master/update.sh
mv update.sh ./blocklists
chmod +x ./blocklists/update.sh
cd $DIR/templates/boxtools/var/www
echo  " cloning latest verison of Organizr."
git clone https://github.com/causefx/Organizr.git html
echo  " adding prebuilt database files"
cp -r $DIR/templates/html/data  $DIR/templates/boxtools/var/www/html
cd $DIR
cp $DIR/templates/boxtools/* $DIR/boxtools_amd64/ -rf
dpkg-deb -b boxtools_amd64/ boxtools_$VER-amd64.deb
mv boxtools_$VER-amd64.deb ./local_packages
##Remove html folder for next build or it will cause errors
rm $DIR/templates/boxtools/var/www/html -rf
rm $DIR/boxtools_amd64/ -rf
exit 0
