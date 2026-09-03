#!/bin/sh
# Build iStoreOS rootfs using ImageBuilder
# Target: armsr/armv8

mkdir -p packages
mkdir -p files/etc/openclash/core
# Download clash_meta
META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
wget -qO- $META_URL | tar xOvz > files/etc/openclash/core/clash_meta
chmod +x files/etc/openclash/core/clash_meta
# Download GeoIP and GeoSite
wget -q https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat -O files/etc/openclash/GeoIP.dat
wget -q https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat -O files/etc/openclash/GeoSite.dat
URL=$(curl -s https://api.github.com/repos/vernesong/OpenClash/releases/latest \
     | grep "browser_download_url.*ipk" \
     | head -n1 \
     | cut -d '"' -f 4)
    #echo "OpenClash latest ipk: $URL"
    wget "$URL" -P packages/

make image \
  PACKAGES="$(tr '\n' ' ' < packages.list) luci-app-openclash luci-compat bash curl ca-bundle ip-full iptables-mod-tproxy iptables-mod-extra kmod-tun kmod-inet-diag unzip coreutils-nohup ruby ruby-yaml" \
  FILES=files
