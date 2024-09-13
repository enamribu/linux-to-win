#!/bin/bash

#================================================== ===
# System Request: Debian/Ubuntu
# Author: dylanbai8
# Dscription: OpenVZ virtualization (architecture) VPS one-click installation of Windows system
# Open Source: https://github.com/dylanbai8/Onekey_OpenVZ_Install_Windows
# Official document: https://oo0.bid
#================================================== ===




# Installing Remote Desktop for Debian
install_lxde_vnc(){

# Uninstall or remove unnecessary system services
apt-get purge apache2 -y

# Upgrading Debian
apt-get update -y

# Install LXDE+VncServer desktop environment
apt-get install xorg lxde-core -y
apt-get install tightvncserver -y
apt-get install curl -y

# Set VNC password
echo "----------------------------------------"
echo "Follow the prompts to set the VNC Password remote desktop password"
echo "----------------------------------------"
vncserver :1
vncserver -kill :1

# Automatically start LXDE desktop when VNC starts
sed -i '/starlxde/'d /root/.vnc/xstartup
echo "starlxde &" >> /root/.vnc/xstartup

chmod +x /root/.vnc/xstartup
}




install_lxde_vnc_menu(){
local_ip=`curl -4 ip.sb`
clear
echo "----------------------------------------"
echo "Prompt: Lxde+VNC remote desktop installed successfully"
echo "VNC server: ${local_ip}:1 not started"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to return to the menu..."
clear
menu
}




# Add firefox browser and simplified Chinese fonts
add_firefox_ttf(){
apt-get install iceweasel -y
apt-get install ttf-arphic-ukai ttf-arphic-uming ttf-arphic-gbsn00lp ttf-arphic-bkai00mp ttf-arphic-bsmi00lp -y

clear
echo "----------------------------------------"
echo "Tip: Firefox browser and Simplified Chinese fonts installed successfully"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to return to the menu..."
clear
menu
}




# Install qemu+win virtual machine
install_qemu_win(){

# Install qemu virtual machine
apt-get install qemu -y

# Install win to the virtual machine
wget https://www.dropbox.com/s/gq3e3feukskw72k/winxp.img
mkdir /root/IMG
mv winxp.img /root/IMG/win.img

	touch /root/.vnc/ram.txt
	cat <<EOF > /root/.vnc/ram.txt
512
EOF
}




install_qemu_win_menu(){
local_ip=`curl -4 ip.sb`
clear
echo "----------------------------------------"
echo "Prompt: Installation of Qemu+WindowsXP virtual machine successful"
echo "WindowsXP default startup memory 512M hard disk 4G"
echo "Remote desktop address: ${local_ip}:3389 not started"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to return to the menu..."
clear
menu
}




check_vnc_install_qemu_win(){
if [[ -e /usr/bin/vncserver ]]; then
install_qemu_win
else
install_lxde_vnc
install_qemu_win
fi
}




# Start VNC+lxde/qemu_win
start_vnc(){
vncserver -kill :1
lsof -i:"3389" | awk '{print $2}' | grep -v "PID" | xargs kill -9

getram=$(cat /root/.vnc/ram.txt)

vncserver :1
qemu-system-x86_64 -hda /root/IMG/win.img -m ${getram}M -smp 1 -daemonize -vnc :2 -net nic,model=virtio -net user -redir tcp:3389::3389

local_ip=`curl -4 ip.sb`
clear
echo "----------------------------------------"
echo "Prompt: Start Lxde+VNC (+WindowsXP if installed) successfully"
echo "VNC server: ${local_ip}:1"
echo ""
echo "If Windows XP is installed, it will take about 5 minutes to connect to the desktop"
echo "VNC server: ${local_ip}:2"
echo "Remote desktop address: ${local_ip}:3389"
echo "Username: administrator Password: abfan.com"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to return to the menu..."
clear
menu
}

# Close VNC+lxde/qemu_win
stop_vnc(){
vncserver -kill :1
lsof -i:"3389" | awk '{print $2}' | grep -v "PID" | xargs kill -9

clear
echo "----------------------------------------"
echo "Tip: Close Lxde+VNC (+WindowsXP if started) successfully"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to return to the menu..."
clear
menu
}




# Set Windows startup memory
set_win_ram(){
if [[ -e /root/IMG/win.img ]]; then

clear
echo "----------------------------------------"
echo "Please enter the RAM value to be set, such as: 1024"
echo "----------------------------------------"
echo ""

read -e -p "Please input:" ram
[[ -z ${ram} ]] && ram="none"
	if [ "${ram}" = "none" ]; then
	set_win_ram
	fi

	touch /root/.vnc/ram.txt
	cat <<EOF > /root/.vnc/ram.txt
${ram}
EOF

clear
echo "----------------------------------------"
echo "The operation has been completed. The current Windows virtual machine memory is: ${ram}M"
echo "Restart the Windows virtual machine to take effect"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to return to the menu..."
clear
menu

else

clear
echo "----------------------------------------"
echo "No Windows system image found, please install first"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to return to the menu..."
clear
menu

fi
}




win_iso_install(){
clear
echo "----------------------------------------"
echo " Note: This command must be executed inside the VNC Remote Desktop"
echo "After the installation is complete, log in to the Windows system:"
echo " 1. My computer - right click property - allow remote desktop"
echo "2.Add account password"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to continue! Exit with 'Ctrl'+'C' !"

mv /root/*.iso /root/win.iso

if [[ -e /root/win.iso ]]; then

apt-get install qemu -y

win_iso_ram_disk

	touch /root/.vnc/ram.txt
	cat <<EOF > /root/.vnc/ram.txt
${nram}
EOF

rm -rf /root/IMG
mkdir /root/IMG
qemu-img create /root/IMG/win.img ${ndisk}G

qemu-system-x86_64 -cdrom /root/win.iso -m ${nram}M -boot d /root/IMG/win.img -k en-us

clear
echo "----------------------------------------"
echo "After the installation is complete, log in to the Windows system:"
echo " 1. My computer - right click property - allow remote desktop"
echo "2.Add account password"
echo "Back to shell Start VNC to run New Windows system in the background"
echo "----------------------------------------"

else

clear
echo "----------------------------------------"
echo "No iso image file detected! Cancel installation"
echo "Please manually download the iso system image into the /root/ directory"
echo "Note: The image file extension must be .iso lowercase"
echo "----------------------------------------"

fi
}




win_iso_ram_disk(){

clear
echo "----------------------------------------"
echo "Enter the RAM value to be set, for example: 1024"
echo "----------------------------------------"
echo ""

read -e -p "please enter (Default size 512):" nram
[[ -z ${nram} ]] && nram="512"

echo ""
echo "----------------------------------------"
echo "Enter the hard disk value to be set, for example: 10"
echo "----------------------------------------"
echo ""

read -e -p "please enter (Default size 10):" ndisk
[[ -z ${ndisk} ]] && ndisk="10"

}




winxp_iso_install(){
cd /root
wget https://www.dropbox.com/s/x20vw6bkwink0fm/winxp.iso
win_iso_install
}




# Uninstall all
unstall_all(){

# Uninstall lxde and vnc
vncserver -kill :1

apt-get purge xorg -y
apt-get purge lxde -y
apt-get purge tightvncserver -y
apt-get purge curl -y

rm -rf /root/.vnc
rm -rf /root/Desktop
rm -rf /root/.cache
rm -rf /root/.config
rm -rf /root/.dbus
rm -rf /root/.gconf
rm -rf /root/.gvfs
rm -rf /root/.Xauthority
rm -rf /root/.xsession-errors

# Uninstall Firefox browser and Simplified Chinese fonts
apt-get purge iceweasel -y
apt-get purge ttf-arphic-ukai ttf-arphic-uming ttf-arphic-gbsn00lp ttf-arphic-bkai00mp ttf-arphic-bsmi00lp -y

# Uninstall the qemu virtual machine
lsof -i:"3389" | awk '{print $2}' | grep -v "PID" | xargs kill -9
apt-get purge qemu -y

# Delete the IMG image
if [[ -e /root/IMG/win.img ]]; then

echo "----------------------------------------"
echo "It is detected that the Windows system image has been installed. Do you want to delete it?"
echo "----------------------------------------"
echo ""

read -e -p "Please enter (y/n):" rmIMG
case ${rmIMG} in
	[yY][eE][sS]|[yY])
	rm -rf /root/IMG
	echo "/root/IMG/win.img system image has been deleted"
	;;
	*)
	echo "Cancel deletion operation image location: /root/IMG/win.img"
esac

fi

clear
echo "----------------------------------------"
echo "Uninstalled Lxde+VNC, FireFox+ttf, Qemu+Windows successfully"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to return to the menu..."
clear
menu
}




get_help(){
local_ip=`curl -4 ip.sb`
clear
echo "----------------------------------------"
echo "**** Customize the Windows system version****"
echo "----------------------------------------"
echo ""
echo "1. Execute 1 and 4 in the menu to install and start Lxde+VNC service"
echo ""
echo "2. Manually download the Windows system iso image file to the /root/ directory"
echo ""
echo "Take the deep simplified version of Windows XP as an example (supports original installation and Ghost system)"
echo " cd /root "
echo " wget https://www.dropbox.com/s/x20vw6bkwink0fm/winxp.iso"
echo ""
echo "3. Use Windows VNC client to connect to remote desktop"
echo ""
echo "a.VNC server address: ${local_ip}:1"
echo "Windows client download address:"
echo "https://github.com/dylanbai8/Onekey_OpenVZ_Install_Windows/raw/master/VNC-4.0-x86_CN.exe"
echo ""
echo " b. Open the terminal in the VNC desktop and execute the following command: "
echo ""
echo " bash w.sh windows"
echo ""
echo "Note: This command must be executed in the VNC remote desktop"
echo "Follow the prompts to set the virtual machine memory and hard disk size. The default is 512M memory and 10G hard disk."
echo "After installing the system as prompted: 1. My Computer - Right-click Properties - Allow Remote Desktop 2. Add a power-on password"
echo ""
echo "After debugging is completed, return to the shell and execute the script to start VNC to run the new Windows system in the background"
echo ""
echo ""
echo " c. If you want to install Windows XP system, just execute bash w.sh windowsxp in VNC, it will automatically download the image and perform the installation"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to return to the menu..."
clear
menu
}




# Installation Menu
menu(){
echo "----------------------------------------"
echo "1. One-click installation of Lxde+VNC remote desktop"
echo "2. Add Firefox browser and Simplified Chinese fonts"
echo ""
echo "3. One-click installation of Qemu+WindowsXP virtual machine"
echo ""
echo "4. Start Lxde+VNC (+WindowsXP if installed)"
echo "5. Close Lxde+VNC (+WindowsXP if started)"
echo ""
echo "6. Set WindowsXP startup memory (default 512M)"
echo ""
echo "7. Customize the Windows system version installation"
echo ""
echo "8. Uninstall all"
echo "9. Exit the script"
echo "----------------------------------------"
echo ""

read -e -p "Please enter the corresponding number:" num
case $num in
	1)
	install_lxde_vnc
	install_lxde_vnc_menu
	;;
	2)
	add_firefox_ttf
	;;
	3)
	check_vnc_install_qemu_win
	install_qemu_win_menu
	;;
	4)
	start_vnc
	;;
	5)
	stop_vnc
	;;
	6)
	set_win_ram
	;;
	7)
	get_help
	;;
	8)
	unstall_all
	;;
	9)
	exit 0
	;;
	*)
	clear
	menu
esac
}




# Check root permissions
if [ `id -u` == 0 ]; then
	echo "The current user is the root user to start the installation process"
else
	echo "The current user is not the root user, please switch to the root user and re-execute the script"
	exit 1
fi




# Script Menu
case "$1" in
	windows)
	win_iso_install
	;;
	Windows XP)
	winxp_iso_install
	;;
	*)
	clear
	menu
esac


# Please keep the copyright when reprinting: https://github.com/dylanbai8/Onekey_OpenVZ_Install_Windows
