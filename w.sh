#!/bin/bash

echo "Pilih OS yang ingin anda install"
echo "	1) Windows 2019(Default)"
echo "	2) Windows 2016"
echo "	3) Windows 2012"
echo "	4) Windows 10"
echo "	5) Windows 2022"
echo "	6) Pakai link gz mu sendiri"

read -p "Pilih [1]: " PILIHOS

case "$PILIHOS" in
	1|"") PILIHOS="http://139.59.227.187/windows2019.gz"  IFACE="Ethernet Instance 0 2";;
	2) PILIHOS="http://139.59.227.187/windows2016.gz"  IFACE="Ethernet Instance 0 2";;
	3) PILIHOS="http://139.59.227.187/windows2012.gz"  IFACE="Ethernet";;
	4) PILIHOS="http://139.59.227.187/windows10.gz"  IFACE="Ethernet Instance 0 2";;
	5) PILIHOS="http://139.59.227.187/windows2022.gz"  IFACE="Ethernet Instance 0 2";;
	6) read -p "Masukkan Link GZ mu : " PILIHOS;;
	*) echo "pilihan salah"; exit;;
esac

wget  -O reinstall.sh 'https://raw.githubusercontent.com/bin456789/reinstall/refs/heads/main/reinstall.sh' && bash reinstall.sh dd --img $PILIHOS

reboot
