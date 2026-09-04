#!/bin/sh

# Build iStoreOS rootfs using ImageBuilder
# Target: armsr/armv8

make image \
  PACKAGES="$(tr '\n' ' ' < packages.list)" \
  FILES=files

make image PROFILE=generic PACKAGES="$PKGS" ROOTFS_TAR=./rootfs.tar.gz V=s

ROOT_DIR="./build_dir/target-aarch64_generic_musl/root-armsr"
tar --exclude=./dev -czf ./rootfs.tar.gz -C "${ROOT_DIR}" .

echo "Generated rootfs.tar.gz:"
ls -lh ./rootfs.tar.gz
