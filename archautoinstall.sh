#!/bin/bash

timedatectl set-ntp true

echo "WARNING!!! USE THE DOS/MBR IF YOUR BIOS DOES NOT SUPPORT UEFI, AND ONLY SUPPORT LEGACY MODE"
echo "ALSO DON'T FORGET TO TURN ON THE BOOTABLE FLAG!!! OTHERWISE, YOUR SYSTEM WOULD NOT BOOT!!"
fdisk /dev/sda

mkfs.ext4 /dev/sda1

echo "Create your swap partition!"
cfdisk

mkswap /dev/sda2
swapon /dev/sda2

mount /dev/sda1 /mnt

pacstrap /mnt base linux-zen linux-zen-headers nano gedit grub dhcpcd sudo htop git iw net-tools

genfstab -U /mnt >> /mnt/etc/fstab

echo "WARNING!! THE INSTALLATION IS STILL NOT COMPLETED YET, YOU NEED TO ENTER THE CHROOT PHASE"
echo "and run the script sh /tmp/autoinstallstep2.sh" 
echo " TO CONTINUE THE INSTALLATION!! "
echo "THIS MESSAGE WILL DISAPPEAR ONCE YOU ENTER THE CHROOT MODE!!!"
read -p "Press enter if you're ready to go to the next step"

mkdir /mnt/tmp
touch /mnt/tmp/autoinstallstep2.sh

# Writing the installation script inside for the chroot phase
echo '
#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

hwclock --systohc

echo "Uncomment one of your locale"
nano /etc/locale.gen

locale-gen

touch /etc/locale.conf

cat /etc/locale.gen >> /etc/locale.conf

echo "SET YOUR ROOT PASSWORD!!!"
passwd

echo "Installing the grub"
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

exit
' >> /mnt/tmp/autoinstallstep2.sh

arch-chroot /mnt /tmp/autoinstallstep2.sh

umount -R /mnt

reboot
