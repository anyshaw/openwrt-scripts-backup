#!/bin/sh

#apt-get install g++ libncurses5-dev zlib1g-dev bison flex unzip autoconf gawk make gettext gettext texinfo sharutils gcc binutils ncurses-term patch bzip2 libbz2-dev libz-dev asciidoc subversion sphinxsearch libtool git git-core curl

cd ~/openwrt

git clone git://git.openwrt.org/openwrt.git barrier_breaker
git clone git://github.com/sancome/openwrt-plus.git
#git clone git://github.com/binux/yaaw.git
#git clone git://github.com/ziahamza/webui-aria2.git

cp ./barrier_breaker/feeds.conf.default ./barrier_breaker/feeds.conf
#echo "src-git exopenwrt https://github.com/black-roland/exOpenWrt.git" >> ./barrier_breaker/feeds.conf
#echo "src-git mwan git://github.com/Adze1502/mwan.git" >> ./barrier_breaker/feeds.conf

./barrier_breaker/scripts/feeds update -a
./barrier_breaker/scripts/feeds install -a

#delete some files from openwrt-plus
rm -rf ./openwrt-plus/feeds/packages/libs/glib2
rm -rf ./openwrt-plus/feeds/packages/libs/libffi

#operating package directory
#package install
cp -rf ./openwrt-plus/package/* ./barrier_breaker/package/

#patch openssl
mv ./barrier_breaker/package/openssl/Makefile.diff ./barrier_breaker/package/libs/openssl/
rm -rf ./barrier_breaker/package/openssl
patch -p0 ./barrier_breaker/package/libs/openssl/Makefile < ./barrier_breaker/package/libs/openssl/Makefile.diff
rm -rf ./barrier_breaker/package/libs/openssl/Makefile.diff

#operating update directory
#remove old packages
rm -rf ./barrier_breaker/feeds/packages/multimedia/gst-plugins-bad
rm -rf ./barrier_breaker/feeds/packages/multimedia/gst-plugins-base
rm -rf ./barrier_breaker/feeds/packages/multimedia/gst-plugins-good
rm -rf ./barrier_breaker/feeds/packages/multimedia/gst-plugins-ugly
rm -rf ./barrier_breaker/feeds/packages/multimedia/gstreamer

#copy new packages
cp -rf ./openwrt-plus/feeds/* ./barrier_breaker/feeds/

#patch luci
patch -p0 ./barrier_breaker/feeds/luci/contrib/package/luci/Makefile < ./barrier_breaker/feeds/luci/contrib/package/luci/Makefile.diff
rm ./barrier_breaker/feeds/luci/contrib/package/luci/Makefile.diff

#operating fils directory
#copy config files
cp -rf ./openwrt-plus/files ./barrier_breaker/

#add yaaw
#cp -rf ./yaaw ./barrier_breaker/feeds/luci/modules/admin-core/root/www/
#add webui-aria2
#cp -rf ./webui-aria2 ./barrier_breaker/feeds/luci/modules/admin-core/root/www/

#delete openwrt-plus
rm -rf ./openwrt-plus

#save dl files to dl-barrier_breaker
if [ ! -d dl-barrier_breaker ]; then
    mkdir ~/openwrt/dl-barrier_breaker
fi

#make
cd barrier_breaker
# create symbolic link to download directory
if [ ! -d dl ]; then
    ln -s ~/openwrt/dl-barrier_breaker dl
fi

#cp ../zd_openwrt_scripts/barrier_breaker/config.db120 ./.config
#make defconfig
#make menuconfig
#make V=99
