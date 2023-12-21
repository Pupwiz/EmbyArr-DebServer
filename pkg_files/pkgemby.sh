#!/bin/bash
DIR=$(pwd)
rm $DIR/local_packages/emby*.deb
function github_latest_version() {
    repo=$1
    curl -fsSLI -o /dev/null -w %{url_effective} https://github.com/${repo}/releases/latest | grep -o '[^/]*$'
}
os_arch=$(dpkg --print-architecture)
current=$(github_latest_version MediaBrowser/Emby.Releases)
wget -P $DIR/local_packages/  https://github.com/MediaBrowser/Emby.Releases/releases/download/${current}/emby-server-deb_${current}_${os_arch}.deb 
exit

