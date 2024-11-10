#!/bin/bash

echo "Pilih OS yang ingin anda install"
echo "  1) Windows 2012"
echo "  2) Windows 2016"
echo "  3) Windows 2019"
echo "  4) Windows 2022"
echo "  5) Windows 10"
echo "  6) Link GZ"

read -p "Pilih : " PILIHOS

case "$PILIHOS" in
    1|"") PILIHOS="http://139.59.227.187/windows2012.gz"  IFACE="Ethernet Instance 0 2";;
    2) PILIHOS="http://139.59.227.187/windows2016.gz"  IFACE="Ethernet Instance 0 2";;
    3) PILIHOS="http://139.59.227.187/windows2019.gz"  IFACE="Ethernet";;
    4) PILIHOS="http://139.59.227.187/windows2022.gz"  IFACE="Ethernet Instance 0 2";;
    5) PILIHOS="http://139.59.227.187/windows10.gz"  IFACE="Ethernet Instance 0 2";;
    6) read -p "Masukkan Link GZ : " PILIHOS;;
    *) echo "Pilihan salah"; exit;;
esac

# Menambahkan opsi untuk memilih port
read -p "Apakah Anda ingin menambahkan port? (y/n, default: n) : " ADDPORT
ADDPORT=${ADDPORT:-n}  # Default 'n' jika tidak ada input

if [[ "$ADDPORT" == "y" || "$ADDPORT" == "Y" ]]; then
    read -p "Masukkan port (default: 3389) : " PORT
    PORT=${PORT:-3389}  # Default port 3389 jika tidak ada input
else
    PORT=3389  # Port default jika tidak memilih untuk menambah port
fi

echo "OS yang dipilih: $PILIHOS"
echo "Port yang dipilih: $PORT"

# Mengunduh dan menjalankan script reinstall
wget  -O reinstall.sh 'https://raw.githubusercontent.com/bin456789/reinstall/refs/heads/main/reinstall.sh' && bash reinstall.sh dd --img $PILIHOS

reboot
