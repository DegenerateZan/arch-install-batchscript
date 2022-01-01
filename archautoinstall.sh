#!/bin/bash


timedatectl set-ntp true

echo "WARNING!!! USE THE DOS/MBR IF YOUR BIOS DOES NOT SUPPORT UEFI, AND ONLY SUPPORT LEGACY MODE"
echo "ALSO DONT FORGET TO TURN ON THE BOOTABLE FLAG!!! OTHERWISE YOUR SYSTEM WOULD NOT BOOT!!"
fdisk /dev/sda

mkfs.ext4 /dev/root_partition

#uncomment the line below me if you want to use the swap partition

#mkswap /dev/swap_partition

mount /dev/root_partition /mnt

swapon /dev/swap_partition

pacstrap /mnt base linux-zen linux-zen-headers nano gedit grub network-manager dhcpcd sudo htop git

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

hwclock --systohc

echo "uncoment one of your locale"
nano /etc/locale.gen

locale-gen

cat /etc/locale.gen >> /etc/locale.conf

echo "SET YOUR ROOT PASSWORD!!!"
passwd
