#!/bin/bash
DIR=$(pwd)
rm $DIR/local_packages/unpackerr*.deb
type=amd64.deb
unpackerrlatest=$(curl -s https://api.github.com/repos/Unpackerr/unpackerr/releases/latest | jq -r ".assets[] | select(.name | test(\"${type}\")) | .browser_download_url")
wget $unpackerrlatest -P $DIR/local_packages/
exit
