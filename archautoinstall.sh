#!/bin/bash


timedatectl set-ntp true

echo "WARNING!!! USE THE DOS/MBR IF YOUR BIOS DOES NOT SUPPORT UEFI, AND ONLY SUPPORT LEGACY MODE"
echo "ALSO DONT FORGET TO TURN ON THE BOOTABLE FLAG!!! OTHERWISE YOUR SYSTEM WOULD NOT BOOT!!"
fdisk /dev/sda

mkfs.ext4 /dev/sda

echo "create your swap partition!"

cfdisk

mkswap /dev/sda2

mount /dev/sda1 /mnt

swapon /dev/sda2

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

echo "installing the grub"

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

exit

umount -R /mnt

reboot
