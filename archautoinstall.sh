#!/bin/bash


timedatectl set-ntp true

echo "WARNING!!! USE THE DOS/MBR IF YOUR BIOS DOES NOT SUPPORT UEFI, AND ONLY SUPPORT LEGACY MODE"
echo "ALSO DONT FORGET TO TURN ON THE BOOTABLE FLAG!!!"
fdisk /dev/sda

mkfs.ext4 /dev/root_partition
mkswap /dev/swap_partition

mount /dev/root_partition /mnt

swapon /dev/swap_partition

pacstrap /mnt base linux-zen linux-zen-headers nano gedit grub network-manager dhcpcd sudo htop

arch-chroot /mnt
