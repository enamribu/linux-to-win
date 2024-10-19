#!/bin/bash
#
# CREATED By NIXPOIN.COM
#
echo "Pilih OS yang ingin anda install"
echo "	1) Windows 2019(Default)"
echo "	2) Windows 2016"
echo "	3) Windows 2012"
echo "	4) Windows 10"
echo "	5) Windows 2022"
echo "	6) Pakai link gz mu sendiri"

read -p "Pilih [1]: " PILIHOS

case "$PILIHOS" in
	1|"") PILIHOS="https://files.sowan.my.id/windows2019.gz"  IFACE="Ethernet Instance 0 2";;
	2) PILIHOS="https://files.sowan.my.id/windows2016.gz"  IFACE="Ethernet Instance 0 2";;
	3) PILIHOS="https://files.sowan.my.id/windows2012.gz"  IFACE="Ethernet";;
	4) PILIHOS="https://files.sowan.my.id/windows10.gz"  IFACE="Ethernet Instance 0 2";;
	5) PILIHOS="https://files.sowan.my.id/windows2022.gz"  IFACE="Ethernet Instance 0 2";;
	6) read -p "Masukkan Link GZ mu : " PILIHOS;;
	*) echo "pilihan salah"; exit;;
esac


IP4=$(curl -4 -s icanhazip.com)
GW=$(ip route | awk '/default/ { print $3 }')


cat >/tmp/net.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)
net user Administrator $PASSADMIN


netsh -c interface ip set address name="$IFACE" source=static address=$IP4 mask=255.255.240.0 gateway=$GW
netsh -c interface ip add dnsservers name="$IFACE" address=1.1.1.1 index=1 validate=no
netsh -c interface ip add dnsservers name="$IFACE" address=8.8.4.4 index=2 validate=no

cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"
del /f /q net.bat
exit
EOF

wget  -O reinstall.sh 'https://raw.githubusercontent.com/bin456789/reinstall/refs/heads/main/reinstall.sh' && bash reinstall.sh dd --img $PILIHOS
