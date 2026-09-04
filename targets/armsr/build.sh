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

API_URL="https://api.github.com/repos/pymumu/smartdns/releases/latest"
# 2. 请求API，提取ipk下载链接，匹配 aarch64 / all 架构
SMARTDNS_URLS=$(curl -s -H "Accept: application/vnd.github.v3+json" "$API_URL" \
    | grep -oE '"browser_download_url": *"[^"]+\.ipk"' \
    | cut -d'"' -f4 \
    | grep -E "(aarch64|all)")

if [ -n "$SMARTDNS_URLS" ]; then
    mkdir -p packages/
    for url in $SMARTDNS_URLS; do
        echo "   -> 下载: $url"
        wget --retry-connrefused --tries=3 -q "$url" -P packages/
        if [ $? -ne 0 ]; then
            echo "❌ 下载失败: $url"
            exit 1
        fi
    done
    echo "✅ 下载完成，安装包已保存在 packages/ 目录中。"
else
    echo "❌ 错误: 无法解析到符合条件的 SmartDNS ipk 下载链接！"
    echo "API原始返回调试："
    curl -s -H "Accept: application/vnd.github.v3+json" "$API_URL" | head -200
    exit 1
fi


make image PROFILE=generic PACKAGES="$PKGS" ROOTFS_TAR=./rootfs.tar.gz V=s

ROOT_DIR="./build_dir/target-aarch64_generic_musl/root-armsr"
tar --exclude=./dev -czf ./rootfs.tar.gz -C "${ROOT_DIR}" .

echo "Generated rootfs.tar.gz:"
ls -lh ./rootfs.tar.gz
