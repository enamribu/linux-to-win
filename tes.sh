#!/bin/sh

wget  -O reinstall.sh 'https://raw.githubusercontent.com/bin456789/reinstall/refs/heads/main/reinstall.sh'

echo "  1) Windows 2012"
echo "  2) Windows 2016"
echo "  3) Windows 2019"
echo "  4) Windows 2022"
echo "  5) Windows 10"
echo "  6) Windows 10 US"
echo -n "Masukkan Pilihan: "
read N
case $N in
  1) bash reinstall.sh dd --img 'http://139.59.227.187/windows2012.gz' ;;
  2) bash reinstall.sh dd --img 'http://139.59.227.187/windows2016.gz' ;;
  3) bash reinstall.sh dd --img 'http://139.59.227.187/windows2019.gz' ;;
  4) bash reinstall.sh dd --img 'http://139.59.227.187/windows2022.gz' ;;
  5) bash reinstall.sh dd --img 'http://139.59.227.187/windows10.gz' ;;
  6) bash reinstall.sh dd --img 'https://download1529.mediafire.com/hqfm3ogkl8sguOSI-wQ-O4lRJ6xPWfr5v7wKuh8XYm0sHv2jQ07Kej1T4X0heImIYONXFxo0oErQZYSzHd89rCiZWPRO-bpI1tsvtUDVJrAi4kJKs7UmihewZjTCIZ6Zcxj66jmuEA8OM3YfKQMSaVyn-hFTUsvvAJzUJ_Vgx6VO/6rzrtbg7ity8gkh/windows10.gz' ;;
  *) echo "Wrong input!" ;;
esac
reboot
