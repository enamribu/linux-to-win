#!/bin/bash

echo "Pilih OS yang ingin anda install"
echo "    1) Windows 2012"
echo "    2) Windows 2016"
echo "    3) Windows 2019"
echo "    4) Windows 2022"
echo "    5) Windows 10"
echo "    6) Link GZ"

read -p "Pilih : " PILIHOS

# Menentukan URL OS dan interface berdasarkan pilihan
case "$PILIHOS" in
    1|"") PILIHOS="http://139.59.227.187/windows2012.gz"; IFACE="Ethernet Instance 0 2";;
    2) PILIHOS="http://139.59.227.187/windows2016.gz"; IFACE="Ethernet Instance 0 2";;
    3) PILIHOS="http://139.59.227.187/windows2019.gz"; IFACE="Ethernet";;
    4) PILIHOS="http://139.59.227.187/windows2022.gz"; IFACE="Ethernet Instance 0 2";;
    5) PILIHOS="http://139.59.227.187/windows10.gz"; IFACE="Ethernet Instance 0 2";;
    6) 
        read -p "Masukkan Link GZ : " PILIHOS
        IFACE="Ethernet"  # Set default interface jika pilihan 6
        ;;
    *) 
        echo "Pilihan salah"
        exit 1
        ;;
esac

echo "Pakai port atau tidak?"
echo "    1) CUSTOM PORT"
echo "    2) TIDAK"

read -p "Pilih : " PORT_CHOICE

# Menangani pilihan port
case "$PORT_CHOICE" in
    1)
        read -p "Masukkan PORT : " PORT
        ;;
    2)
        PORT="default"  # Jika tidak pakai port custom, set ke default
        ;;
    *)
        echo "Pilihan salah"
        exit 1
        ;;
esac

# Mengunduh script dan menjalankannya dengan parameter yang sesuai
wget -O reinstall.sh 'https://raw.githubusercontent.com/bin456789/reinstall/refs/heads/main/reinstall.sh' && \
bash reinstall.sh dd --img "$PILIHOS" --rdp-port "$PORT"

# Reboot setelah proses selesai
reboot
