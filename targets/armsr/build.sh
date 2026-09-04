#!/bin/sh

# Build iStoreOS rootfs using ImageBuilder
# Target: armsr/armv8

make image \
  PACKAGES="$(tr '\n' ' ' < packages.list)" \
  FILES=files

make image PROFILE=generic PACKAGES="$PKGS" ROOTFS_TAR=./rootfs.tar.gz V=s

ls -lh ./rootfs.tar.gz
