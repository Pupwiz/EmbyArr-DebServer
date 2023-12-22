Sharing my pesonal debian bookworm server iso builder. This is mainly designed to be use as a home server with local access to your IP.

I started this journey as friends made request to have access to my server. The loads started to get to much so this was designed and built for them to be able to 
just pop a usb stick into a barebones machine and have their own server. I would then get access through tailscale for support and then they would slowly start learning to use on their own.



Special note: Use extreme caution as the installer doesn't ask any questions during install and I mean NONE....

If you have extra drives that have data on them that you need to keep, make sure that they are disconnected before using this installer to prevent wiping data of a needed drive..!

It is hard scripted to select sda hard drive and format it to ext4 wiping the disk. If there is only one disk at the time of install then it should only select the disk that you want the OS installed on.





1st off I am no coder or even programmer. Most, if not all code is pulled from somewhere off the net from help sites or examples from other comunitties.
I was mainly intrested in keeping things as small as possible debian server based on this it gets only whats need to install all apps listed below. If security is a problem you need to address these on your own.

I recommend building and testing on VM or proxmox etc before you expose anything to the net.

That being said feel free to make suggestions for improvements or better way to code something being done, I sometimes take the simple way around a problem. (not always the best)

I have setup the main user as media and password as bookworm (already breaking the rule). Tested last version on Bookworm 12.4 on a VM with user media and pass bookworm. Apps login as admin/bookworm including main web
and are used throughout the install for logins and need change to suit your needs. I have included a preseed file which includes git in the repo to build the debian build envoirment, for this I just boot the netiso 
into the vm and point it at the preseed file by switching to the help menu on the iso boot and suppling auto url=. After the net install is done clone the repo and run auto-build.sh. It will download and package 
the programs into deb packages and build an installable debian ISO. The scripts have been designed to scan for your local network ip and use it for setting up access to the system.
You can rebuild the iso as many times as you want and each time the script should build with all the latest apps listed below. If there are changes in the newly build deb files, simple-cdd will complain about a checksum missmatch.
You will have to delete the tmp/ folder and re-run the script.

What's installed

Emby media server pre configured on boot - admin and bookworm login ( there is a jellyfin version in the build script but I have better luck porting stuff with emby)

Sonarr - Shows downloading - preconfigured on boot for media

Radarr - Movies downloading - preconfigured on boot for media

Prowlarr - Indexer - preconfigured for Sonarr, Radarr Lidarr, and Readarr

Lidarr - Music downloading - pre configured on boot for media

Readarr - Book downloading - preconfigured on boot for media

Qbittorrent  - torrent download preconfigured for Sonarr, Radarr Lidarr, and Readarr

SABnzbd - nzb download pre configured but will error as you need to supply your own news reader access

Unpackerr -preconfigure to unpack sonarr radarr lidarr and readarr downloads

Flaresolverr - add to aid Prowlarr in bypassing cloudflare ques

wsdd - Windows Net Browsing - https://packages.debian.org/unstable/net/wsdd (can be uninstalled if you don't need support to windows home pc)

sickbeard_mp4_automator - https://github.com/mdhiggins/sickbeard_mp4_automator

tailscale - for remote support - https://tailscale.com/ ( I use the personal key setting from tailscale to allow it to automatically connect to my tailscale hub for intial support this is disable in the required.sh script you need your own key see comments)

Organizr - html web interface - pre configured with access to all the above ARR apps and cloudcmd https://github.com/causefx/Organizr

Cloudcmd (with gritty) - https://cloudcmd.io/ (this can be considered a security risk because of it's access - use with caution and definatly change the pass)
