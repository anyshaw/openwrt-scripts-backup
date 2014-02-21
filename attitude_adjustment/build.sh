#!/bin/sh

#apt-get install g++ libncurses5-dev zlib1g-dev bison flex unzip autoconf gawk make gettext gettext texinfo sharutils gcc binutils ncurses-term patch bzip2 libbz2-dev libz-dev asciidoc subversion sphinxsearch libtool git git-core curl

cd ~/openwrt

git clone git://git.openwrt.org/12.09/openwrt.git attitude_adjustment
git clone git://github.com/sancome/openwrt-plus.git
#git clone git://github.com/binux/yaaw.git
#git clone git://github.com/ziahamza/webui-aria2.git

cp ./attitude_adjustment/feeds.conf.default ./attitude_adjustment/feeds.conf
sed -i 's/.*packages_12.09.*/src-git packages git:\/\/git.openwrt.org\/12.09\/packages.git/' ./attitude_adjustment/feeds.conf
sed -i 's/\/contrib\/package//g' ./attitude_adjustment/feeds.conf
#echo "src-git exopenwrt https://github.com/black-roland/exOpenWrt.git" >> ./attitude_adjustment/feeds.conf
#echo "src-git mwan git://github.com/Adze1502/mwan.git" >> ./attitude_adjustment/feeds.conf

./attitude_adjustment/scripts/feeds update -a
./attitude_adjustment/scripts/feeds install -a

#operating package directory
#package install
cp -rf ./openwrt-plus/package/* ./attitude_adjustment/package/

#patch openssl
patch -p0 ./attitude_adjustment/package/openssl/Makefile < ./attitude_adjustment/package/openssl/Makefile.diff
rm -rf ./attitude_adjustment/package/openssl/Makefile.diff

#operating update directory
#remove old packages
rm -rf ./attitude_adjustment/feeds/packages/libs/glib2
rm -rf ./attitude_adjustment/feeds/packages/multimedia/gst-plugins-bad
rm -rf ./attitude_adjustment/feeds/packages/multimedia/gst-plugins-base
rm -rf ./attitude_adjustment/feeds/packages/multimedia/gst-plugins-good
rm -rf ./attitude_adjustment/feeds/packages/multimedia/gst-plugins-ugly
rm -rf ./attitude_adjustment/feeds/packages/multimedia/gstreamer

#copy new packages
cp -rf ./openwrt-plus/feeds/* ./attitude_adjustment/feeds/

#patch libffi
patch -p0 ./attitude_adjustment/feeds/packages/libs/libffi/Makefile < ./attitude_adjustment/feeds/packages/libs/libffi/Makefile.diff
rm -rf ./attitude_adjustment/feeds/packages/libs/libffi/Makefile.diff

#patch luci
patch -p0 ./attitude_adjustment/feeds/luci/contrib/package/luci/Makefile < ./attitude_adjustment/feeds/luci/contrib/package/luci/Makefile.diff
rm ./attitude_adjustment/feeds/luci/contrib/package/luci/Makefile.diff

#operating fils directory
#copy config files
cp -rf ./openwrt-plus/files ./attitude_adjustment/

#operating something
#copy config files to folder, it's a bug for aa and pandorabox version, not for trunk
cp -rf ./openwrt-plus/feeds/luci/applications/luci-pdnsd/root/etc ./attitude_adjustment/files/
cp -rf ./openwrt-plus/feeds/luci/applications/luci-vsftpd/root/etc ./attitude_adjustment/files/
chmod 644 ./attitude_adjustment/files/etc/pdnsd.conf

#add yaaw
#cp -rf ./yaaw ./attitude_adjustment/feeds/luci/modules/admin-core/root/www/
#add webui-aria2
#cp -rf ./webui-aria2 ./attitude_adjustment/feeds/luci/modules/admin-core/root/www/

#delete openwrt-plus
rm -rf ./openwrt-plus

#save dl files to dl-attitude_adjustment
if [ ! -d dl-attitude_adjustment ]; then
    mkdir ~/openwrt/dl-attitude_adjustment
fi

#make
cd attitude_adjustment
# create symbolic link to download directory
if [ ! -d dl ]; then
    ln -s ~/openwrt/dl-attitude_adjustment dl
fi

#cp ../zd_openwrt_scripts/attitude_adjustment/config.db120 ./.config
#make defconfig
#make menuconfig
#make V=99
