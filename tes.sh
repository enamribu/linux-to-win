#!/bin/bash

echo "Pilih OS yang ingin anda install"
echo "	1) Windows 2012"
echo "	2) Windows 2016"
echo "	3) Windows 2019"
echo "	4) Windows 2022"
echo "	5) Windows 10"
echo "	6) Link GZ"

read -p "Pilih : " PILIHOS

case "$PILIHOS" in
	1|"") PILIHOS="http://139.59.227.187/windows2012.gz"  IFACE="Ethernet Instance 0 2";;
	2) PILIHOS="http://139.59.227.187/windows2016.gz"  IFACE="Ethernet Instance 0 2";;
	3) PILIHOS="http://139.59.227.187/windows2019.gz"  IFACE="Ethernet";;
	4) PILIHOS="http://139.59.227.187/windows2022.gz"  IFACE="Ethernet Instance 0 2";;
	5) PILIHOS="http://139.59.227.187/windows10.gz"  IFACE="Ethernet Instance 0 2";;
	6) read -p "Masukkan Link GZ : " PILIHOS;;
	*) echo "pilihan salah"; exit;;
esac

echo "Pakai port atau tidak"
echo "	1) CUSTOM PORT"
echo "	2) TIDAK"

read -p "Pilih : " PORT

case "$PILIHOS" in
	1) read -p "Masukkan PORT : " PORT;;
	2) wget -O reinstall.sh 'https://raw.githubusercontent.com/bin456789/reinstall/refs/heads/main/reinstall.sh' && bash reinstall.sh dd --img $PILIHOS
	*) echo "pilihan salah"; exit;;
esac

wget -O reinstall.sh 'https://raw.githubusercontent.com/bin456789/reinstall/refs/heads/main/reinstall.sh' && bash reinstall.sh dd --img $PILIHOS --rdp-port $PORT

reboot
