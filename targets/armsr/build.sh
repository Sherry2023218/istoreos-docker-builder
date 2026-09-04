#!/bin/sh

# Build iStoreOS rootfs using ImageBuilder
# Target: armsr/armv8

make image \
  PACKAGES="$(tr '\n' ' ' < packages.list)" \
  FILES=files

cp -v bin/targets/armsr/armv8/generic-rootfs.tar.gz ./rootfs.tar.gz
ls -lh ./rootfs.tar.gz
