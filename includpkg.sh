#!/bin/bash

##Sonarr build custom deb package
DIR=$(pwd)

rm $DIR/local_packages/sonarr*.deb
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

##Radarr custom deb package 

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

## Prowlarr custom deb package 

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

##Readarr custom deb package

rm $DIR/local_packages/readarr*.deb
lastreadarr() { git ls-remote --tags "$1" | cut -d/ -f3- | tail -n1; }
readarr=$(lastreadarr https://github.com/readarr/readarr.git)
mkdir -p $DIR/readarr_amd64/opt
wget --content-disposition 'http://readarr.servarr.com/v1/update/nightly/updatefile?os=linux&runtime=netcore&arch=x64'
VER=$(find ./Readarr*  -name '*.tar.gz'|grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
tar xfz Readarr.develop.*.linux-core-x64.tar.gz -C $DIR/readarr_amd64/opt
rm Readarr.develop.*.linux-core-x64.tar.gz
cp $DIR/templates/readarr/. $DIR/readarr_amd64/ -r
sed -i.bak "/^[[:space:]]*Version:/ s/:.*/: $VER/" $DIR/readarr_amd64/DEBIAN/control
chown -R media: $DIR/readarr_amd64/home $DIR/readarr_amd64/usr
dpkg-deb -b readarr_amd64/ readarr_$VER-amd64.deb
mv readarr_$VER-amd64.deb ./local_packages
rm $DIR/readarr_amd64/ -r

## Lidarr custom deb package 

rm ./local_packages/lidarr*.deb
mkdir -p $(pwd)/lidarr_amd64/opt
wget --content-disposition 'http://lidarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64'
VER=$(find ./Lidarr*  -name '*.tar.gz'|grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
tar xfz Lidarr.master.*.linux-core-x64.tar.gz -C $(pwd)/lidarr_amd64/opt
rm Lidarr.master.*.linux-core-x64.tar.gz
cp $(pwd)/templates/lidarr/* $(pwd)/lidarr_amd64/ -r
sed -i.bak "/^[[:space:]]*Version:/ s/:.*/: $VER/" $DIR/lidarr_amd64/DEBIAN/control
dpkg-deb -b lidarr_amd64/ lidarr_$VER-amd64.deb
mv lidarr_$VER-amd64.deb ./local_packages
rm $DIR/lidarr_amd64/ -r

##adding Unpackerr

rm $DIR/local_packages/unpackerr*.deb
type=amd64.deb
unpackerrlatest=$(curl -s https://api.github.com/repos/Unpackerr/unpackerr/releases/latest | jq -r ".assets[] | select(.name | test(\"${type}\")) | .browser_download_url")
wget $unpackerrlatest -P $DIR/local_packages/

## Adding Emby-Server 

rm $DIR/local_packages/emby*.deb
function github_latest_version() {
    repo=$1
    curl -fsSLI -o /dev/null -w %{url_effective} https://github.com/${repo}/releases/latest | grep -o '[^/]*$'
}
os_arch=$(dpkg --print-architecture)
current=$(github_latest_version MediaBrowser/Emby.Releases)
wget -P $DIR/local_packages/  https://github.com/MediaBrowser/Emby.Releases/releases/download/${current}/emby-server-deb_${current}_${os_arch}.deb 

## adding FlareSolverr for Prowlarr

rm $DIR/local_packages/flaresolverr*.deb
mkdir -p $DIR/flaresolverr_amd64/opt
cd $DIR/flaresolverr_amd64/opt
flare_type=linux_x64
solverr=$(curl -s https://api.github.com/repos/FlareSolverr/FlareSolverr/releases/latest | jq -r ".assets[] | select(.name | test(\"${flare_type}\")) | .browser_download_url")
wget $solverr
tar xvf flaresolverr_linux*.tar.gz
rm flaresolverr_linux*.tar.gz
version=$(cat ./flaresolverr/package.json | grep '"version"' | head -n 1 | awk '{print $2}' | sed 's/"//g; s/,//g')
cp $DIR/templates/flaresolverr/. $DIR/flaresolverr_amd64/ -r
sed -i.bak "/^[[:space:]]*Version:/ s/:.*/: ${version}/" $DIR/flaresolverr_amd64/DEBIAN/control 
chown -R media: $DIR/flaresolverr_amd64/opt
cd $DIR
dpkg-deb -b flaresolverr_amd64 flaresolverr_${version}-amd64.deb
mv flaresolverr_${version}-amd64.deb $DIR/local_packages 
rm flaresolverr_amd64/ -r

##Adding sabnzbd to local pacakages

DIR=$(pwd)
rm $DIR/local_packages/sabnzbd*.deb
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
chown -R media: $DIR/sabnzbd_amd64/home $DIR/sabnzbd_amd64/opt
dpkg-deb -b sabnzbd_amd64/ sabnzbd_4.1.0-amd64.deb
mv $DIR/sabnzbd_4.1.0-amd64.deb $DIR/local_packages 
rm sabnzbd_amd64/ -r

##Adding tailscale to local packages 

wget https://ryzenbox.com/tailscale_1.56.1_amd64.deb -P $DIR/local_packages/

## Adding Jellyfin - I stick with emby seems more stable 

#wget -r -l1 -np "https://repo.jellyfin.org/releases/server/debian/stable/" -A "jellyfin-server_*_amd64.deb,jellyfin-web*all.deb,jellyfin-ffmpeg*-bookworm_amd64.deb"
#for deb in $(find ./repo.jellyfin.org -name '*.deb'); do mv $deb $DIR/local_packages; done
#rm repo.jellyfin.org/ -r

##Building box tools for configs and database templates 

VER=1.06
rm $DIR/local_packages/boxtools*.deb
mkdir -p $DIR/boxtools_amd64/opt
cd $DIR/boxtools_amd64/opt
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git mp4auto
git clone https://github.com/Pupwiz/Scripts.git bt_scripts
mkdir -p blocklists
wget https://raw.githubusercontent.com/Naunter/BT_BlockLists/master/update.sh
mv update.sh ./blocklists
chmod +x ./blocklists/update.sh
mkdir -p $DIR/templates/boxtools/var/www/
cd $DIR/templates/boxtools/var/www
git clone https://github.com/causefx/Organizr.git html
cd $DIR
cp -r $DIR/templates/html/data  $DIR/templates/boxtools/var/www/html
cp $DIR/templates/boxtools/* $DIR/boxtools_amd64 -rf
dpkg-deb -b boxtools_amd64/ boxtools_$VER-amd64.deb
mv boxtools_$VER-amd64.deb ./local_packages
##Remove html folder for next build or it will cause errors
rm $DIR/templates/boxtools/var/www/html -rf
rm $DIR/boxtools_amd64/ -rf
exit 0
