#!/bin/bash

while true; do
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
        1|"") PILIHOS="http://13.229.98.238/windows2012.gz"  IFACE="Ethernet Instance 0 2"; break;;
        2) PILIHOS="http://13.229.98.238/windows2016.gz"  IFACE="Ethernet Instance 0 2"; break;;
        3) PILIHOS="http://13.229.98.238/windows2019.gz"  IFACE="Ethernet"; break;;
        4) PILIHOS="http://13.229.98.238/windows2022.gz"  IFACE="Ethernet Instance 0 2"; break;;
        5) PILIHOS="http://13.229.98.238/windows10.gz"  IFACE="Ethernet Instance 0 2"; break;;
        6) PILIHOS="http://13.229.98.238/windows11.gz"  IFACE="Ethernet Instance 0 2"; break;;
        7) 
            read -p "Masukkan Link GZ : " PILIHOS
            if [[ -n $PILIHOS ]]; then
                break
            else
                echo "Link GZ tidak boleh kosong. Silakan coba lagi."
            fi
            ;;
        *) echo "Pilihan salah. Silakan coba lagi.";;
    esac
done

while true; do
    read -p "Masukkan port (default 3389): " PORT
    PORT=${PORT:-3389}

    if [[ $PORT =~ ^[0-9]+$ ]]; then
        break
    else
        echo "Port harus berupa angka. Silakan coba lagi."
    fi
done

echo "Mengunduh dan menjalankan reinstall.sh dengan port $PORT..."
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh dd --img $PILIHOS --rdp-port $PORT

echo "Restarting..."
reboot
