#!/bin/bash
DIR=$(pwd)
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
exit
