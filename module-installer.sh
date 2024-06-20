#!/bin/bash

# Maintainer: swiftgeek
# Contributor: Kitty Panics

pkgname=8189fs-git
_pkgname=rtl8189ES_linux
pkgver=5.2.0
pkgrel=1
pkgdesc="Kernel module for Realtek RTL8189FTV SDIO wireless devices."
arch=('aarch64')
url="https://github.com/jwrdegoede/rtl8189ES_linux/tree/rtl8189fs"
license=('GPL')
depends=('linux')
source=("git+https://github.com/jwrdegoede/$_pkgname.git#branch=rtl8189fs")
sha256sums=('SKIP')

echo "Step 1: Update package list and install necessary dependencies"
sudo apt-get update
sudo apt-get install -y git build-essential linux-headers-$(uname -r) gcc-aarch64-linux-gnu

echo "Step 2: Clone the repository"
git clone https://github.com/jwrdegoede/$_pkgname.git -b rtl8189fs
cd $_pkgname

echo "Step 3: Get the kernel version"
_KVER=$(uname -r)
echo "Kernel version: $_KVER"

echo "Step 4: Rebuild 'fixdep' utility"
cd /usr/src/linux-headers-$_KVER
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- scripts

echo "Step 5: Build the module"
cd ~/$_pkgname
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- KSRC="/lib/modules/$_KVER/build/"
gzip -9 8189fs.ko

echo "Step 6: Install the module"
sudo install -d /lib/modules/$_KVER/extra/
sudo install -m644 8189fs.ko.gz /lib/modules/$_KVER/extra/8189fs.ko.gz

echo "Step 7: Update module dependencies"
sudo depmod -a

echo "Step 8: Clean up"
cd ..
rm -rf $_pkgname

echo "Installation of $pkgname complete. Please reboot your system to load the new module."
