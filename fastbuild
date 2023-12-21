
#!/bin/sh
#read -s -p "Enter Default Password: " NEWPASS
#export NEWPASS

# Check required packages for builds
DIR=$(pwd)
set -euo pipefail
install_if_not_exist() {
  if dpkg -s "$1" &>/dev/null; then
    PKG_EXIST=$(dpkg -s "$1" | grep "install ok installed")
    if [ -z "$PKG_EXIST" ]; then
      sudo apt install "$1" -y
    fi
  else
    sudo apt install "$1" -y
  fi
}

sudo apt update -y

install_if_not_exist git
install_if_not_exist jq
install_if_not_exist simple-cdd
install_if_not_exist dos2unix
install_if_not_exist libarchive-tools
install_if_not_exist curl
install_if_not_exist dosfstools
install_if_not_exist mtools

##check kali linux debian-cd forked version for bookworm
##there version has been modified to handle bookworm new firmware pattern
ver_debian_cd=$(dpkg-query -f '${Version}' -W debian-cd)
		if dpkg --compare-versions "$ver_debian_cd" lt 3.2.1+kali1; then
			echo "ERROR: You need debian-cd (>= 3.2.1+kali1), you have $ver_debian_cd" >&2
                        kali_org="https://http.kali.org/pool/main"
                        url=$(wget -O- -q --no-check-certificate $kali_org/d/debian-cd | 
                        sed -ne 's/^.*"\([^"]*debian-cd_[^"]*kali1_all\.deb\)".*/\1/p')
                        wget $kali_org/d/debian-cd/$url  
                        # Install the package
                        sudo dpkg -i $url        
                        # Clean up
                        rm "$url"
fi
##Deal with Git file permission not staying.
POSTIN="$DIR/templates/sonarr/DEBIAN/postinst"
if ! [[ $(stat -c "%A" $POSTIN) =~ "x" ]]; then
find $DIR/templates -name "postinst" -exec chmod +x {} \;
fi
DEH="$DIR/disc-end-hook"
if ! [[ $(stat -c "%A" $DEH) =~ "x" ]]; then
 sudo chmod +x "$DEH";
 fi
REQ="$DIR/templates/boxtools/etc/network/if-up.d/required"
if ! [[ $(stat -c "%A" $REQ) =~ "x" ]]; then
 sudo chmod +x "$REQ";
fi
SYD="$DIR/templates/boxtools/usr/lib/systemd/system/"
if [ -z "$(ls -A $DIR/templates/boxtools/home/vpn/.config/openvpn)" ]; then
   clear  
   echo "      Notification........!"
   echo "You have not modified the files in VPN folder with your vpn credentials"
   echo "Qbittorrent with be started without namespace vpn and socat"
sleep 10
yes | cp $SYD/qbittorrent-nox.service.novpn  $SYD/qbittorrent-nox.service
else
clear
   echo "      Notification........!"
   echo "Supplied VPN checked but not verified"
   echo "Setting Qbittorrent service to use Namespace vpn and socat"
sleep 10
 yes | cp $SYD/qbittorrent-nox.service.vpn $SYD/qbittorrent-nox.service
fi
##Check local packages for min required
LP=$(find local_packages/ -type f | wc -l)
if [ "$LP" -lt "11" ]; then
echo "You are missing the ARR required packages!";
echo "Starting to build them now...";
sudo bash $(pwd)/includpkg.sh
fi
##make sure linux readable files - caused problems in past skipping for now back to working
##echo "Making sure all files are Linux readabel"  
##`find $(pwd)/custom_extras/cfg/ -type f -print0 | xargs -0 dos2unix -q --`
BOXT=$DIR/local_packages/boxtools_1.06-amd64.deb
if [ -f "$BOXT" ]; then
    echo "$BOXT exists."
else 
    echo "$BOXT does not exist."
    echo "At a minimum boxtools is required"
    echo " Running boxtools build script"
    bash $DIR/pkg_files/pkgboxtools.sh
fi
`find $(pwd)/templates/ -type f -print0 | xargs -0 dos2unix -q --`
echo "Starting ISO build with custom install files..!"  
build-simple-cdd --conf sda.media.conf --logfile buildlog$(date +%F_%H-%M-%p).log
echo "Build complete, see images folder for ISO..!"  
