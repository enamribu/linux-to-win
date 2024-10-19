#!/bin/bash
#
#
echo "Pilih OS yang ingin anda install"
echo "	1) Windows 2012"
echo "	2) Windows 2016"
echo "	3) Windows 2019"
echo "	4) Windows 2022"
echo "	5) Windows 10"
echo "	6) Link gz"

read -p LINK

case "$LINK" in
	1) LINK='http://139.59.227.187/windows2012.gz' ;;
	2) LINK='http://139.59.227.187/windows2016.gz' ;;
	3) LINK='http://139.59.227.187/windows2019.gz' ;;
	4) LINK='http://139.59.227.187/windows2022.gz' ;;
	5) LINK='http://139.59.227.187/windows10.gz' ;;
	6) read -p "Masukkan Link GZ : " LINK ;;
	*) echo "pilihan salah"; exit;;
esac

wget -O reinstall.sh https://raw.githubusercontent.com/bin456789/reinstall/refs/heads/main/reinstall.sh && bash reinstall.sh dd --img $LINK

echo 'Your server will reboot in 3 second'
sleep 3
reboot
