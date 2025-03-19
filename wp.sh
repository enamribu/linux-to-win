#!/bin/bash

echo "Pilih OS yang ingin anda install"
echo "	1) Windows 2012"
echo "	2) Windows 2016"
echo "	3) Windows 2019"
echo "	4) Windows 2022"
echo "	5) Windows 10"
echo "	6) Windows 11"
echo "	7) Link GZ"

read -p "Pilih : " PILIHOS

case "$PILIHOS" in
	1|"") PILIHOS="http://143.198.210.138/windows2012.gz"  IFACE="Ethernet Instance 0 2";;
	2) PILIHOS="http://143.198.210.138/windows2016.gz"  IFACE="Ethernet Instance 0 2";;
	3) PILIHOS="http://143.198.210.138/windows2019.gz"  IFACE="Ethernet";;
	4) PILIHOS="http://143.198.210.138/windows2022.gz"  IFACE="Ethernet Instance 0 2";;
	5) PILIHOS="http://143.198.210.138/windows10.gz"  IFACE="Ethernet Instance 0 2";;
 	6) PILIHOS="http://143.198.210.138/windows11.gz"  IFACE="Ethernet Instance 0 2";;
	7) read -p "Masukkan Link GZ : " PILIHOS;;
	*) echo "Pilihan salah"; exit;;
esac

read -p "Masukkan port (default 3389): " PORT
PORT=${PORT:-3389}

read -p "Masukkan password untuk RDP: " PASSWORD

echo "Mengunduh dan menjalankan reinstall.sh dengan port $PORT dan password yang diberikan..."
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh dd --img $PILIHOS --rdp-port $PORT --password "$PASSWORD"

echo "Restarting..."
reboot
