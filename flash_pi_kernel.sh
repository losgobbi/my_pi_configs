#!/bin/bash

# very similar to the official docs:
#   https://www.raspberrypi.com/documentation/computers/linux_kernel.html#building

KERNEL_DIR=$1
ARCH=arm64
CC=aarch64-linux-gnu-

echo "type block device:"
read block

bootpart="${block}1"
rootfspart="${block}2"
echo "writing to: $bootpart (BOOT) and $rootfspart (FS)"
echo "are you sure?"
read

# dtbs & kernel img
BOOT_DIR=/mnt/boot_sdcard
sudo mkdir -p $BOOT_DIR
sudo mount $bootpart $BOOT_DIR
sudo cp -v $KERNEL_DIR/arch/arm64/boot/dts/broadcom/bcm*.*dtb $BOOT_DIR
sudo cp -v $KERNEL_DIR/arch/arm64/boot/Image $BOOT_DIR/kernel8.img
sudo umount $BOOT_DIR

# rootfs
ROOTFS_DIR=/mnt/rootfs_sdcard
sudo mkdir -p $ROOTFS_DIR
sudo mount $rootfspart $ROOTFS_DIR
sudo make -C $KERNEL_DIR ARCH=$ARCH CROSS_COMPILE=$CC INSTALL_MOD_PATH=$ROOTFS_DIR modules_install
sudo umount $ROOTFS_DIR
