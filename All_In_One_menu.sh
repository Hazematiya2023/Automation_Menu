#!/bin/bash
clear
# Bash Menu Script 
#/*=========================================================================== 
# |   Copyright (c) 2017 VCC-Cousre, Hazem Mohamed,Ahmed Selim , Amr A.Aziz   |
# |                         All rights reserved                               |
# |                                AASTM                                      |  
# +===========================================================================+
# |                                                                           |
# | FILENAME                                                                  |
# |   ./All_IN_One_menu.sh  under /root/Desktop                               |
# |                                                                           |
# | DESCRIPTION                                                               |
# |    This menu has been developed by bash scripting programming, to         |
# |    automate a lot of tasks.                                               |
# |                                                                           |
# |                                                                           |
# | PLATFORM                                                                  |                                                  
# |   Linux - CentOS 7                                                        |
# |                                                                           |
# | HOSTNAME                                                                  |
# |   /test , IP :                                                            |
# |                                                                           |
# | NOTES                                                                     |
# |   - Before run this menu you must be mount CentOS DVD media.              |
# |   - Copy ks.cfg file from project CD to you Centos root Desktop.          |
# |   - Change permession by chmod 755 All_IN_One_menu.sh.                    |
# |   - You must be copy ISO image of Centos to /var/lib/libvirt/             |
# |                                                                           |
# +===========================================================================+
echo -n $'\E[m'
echo $ ' __      _______ _____   __  __  '                
echo $ ' \ \    / / ____/ ____| |  \/  |'                 
echo $ '  \ \  / / |   | |      | \  / |'___ _ __  _   _ 
echo $ '   \ \/ /| |   | |      | |\/| |/ _ \ |_ \| | | |'
echo $ '    \  / | |___| |____  | |  | |  __/ | | | |_| |'
echo $ '     \/   \_____\_____| |_|  |_|\___|_| |_|\__,_|'  
echo ""
echo ""
echo ""
echo "       Welcome to VCC Menu  - All in Menu Menu"
echo ""
echo ""
echo "         © Designed by  - Hazem Mohamed "
echo ""
echo ""
#declare -i X=0
# Ask user to enter the input to choose select number , to run which option
PS3='Please enter your choice: '
# intialize selection options
options=("Install FTP ${opts[1]}" "Setup Repository server ${opts[2]}" "Setup Repository Client ${opts[3]}" "open firewall ${opts[4]}" "install httdp ${opts[5]}"  "Create Network bridge--change IP before ${opts[6]}" "Install KVM ${opts[7]}" "Create Virtual Machine V1 ${opts[8]}" "Quit ${opts[9]}")
# Switch case funcation
select opt in "${options[@]}"
do
    case $opt in
# case 1 to Copy vsftp RPM file from CentOs Media to Desktop ,then install FTP , then increment X by 1
"Install FTP ${opts[1]}")
cp /run/media/root/*/Packages/vsftpd-3.0.2-9.el7.x86_64.rpm /root/Desktop&& chmod 777 /root/Desktop/vsftpd-3.0.2-9.el7.x86_64.rpm&& rpm -ivh /root/Desktop/vsftpd-3.0.2-9.el7.x86_64.rpm&& service vsftpd restart&& chkconfig vsftpd on
#             ((X++))
            ;;
# case 2 to create repo folder, then copy packages from CentOs media , then install repo server .
"Setup Repository server ${opts[2]}")
# if condition to check if the option one is running or not, if it's running will apply commands , else : will be notify user to enter previos option.
#                if [ $X == 1 ]
#                then
mkdir /var/ftp/pub/myrepo&& cp -a /run/media/root/*/Packages/*  /var/ftp/pub/myrepo/&& createrepo /var/ftp/pub/myrepo/&& cp /run/media/root/*/repodata/2*.xml /root/Desktop&& createrepo -g /root/Desktop/2*.xml  /var/ftp/pub/myrepo/&& yum clean all
#        ((X++))
#                else
#echo " please enter previos option "
#                fi
##PS3='Please press enter to return to main menu: '
            ;;
# Case 3 , setup repo client : move old data to new folder , touch file, then write , then Save
"Setup Repository Client ${opts[3]}")

mkdir /etc/yum.repos.d/old_repo; mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/old_repo/; touch /etc/yum.repos.d/myrepo.repo; 
echo "[test-repo]

name=test

#baseurl=ftp://127.0.0.1/pub/myrepo

baseurl=file:///var/ftp/pub/myrepo

enabled=1

gpgcheck=0

" > /etc/yum.repos.d/myrepo.repo
#PS3='Please press enter to return to main menu: '
            ;;
# Case 4 , Open ftp on Firewall
"open firewall ${opts[4]}")
firewall-cmd --permanent --zone=public --add-port=20/tcp
firewall-cmd --permanent --zone=public --add-port=20/udp
firewall-cmd --permanent --zone=public --add-port=21/tcp
firewall-cmd --permanent --zone=public --add-port=21/udp
firewall-cmd --permanent --add-service=ftp
firewall-cmd --reload
#PS3='Please press enter to return to main menu: '
            ;;
# Case 5 , to install httpd package
"install httdp ${opts[5]}")
yum install httpd
	    ;;
"Create Network bridge--change IP before ${opts[6]}")
yum install bridge-utils -y;
touch /etc/sysconfig/network-scripts/ifcfg-br1;
echo "
DEVICE="br1"
BOOTPROTO="static"
IPADDR="192.168.3.60"
NETMASK="255.255.255.0"
GATEWAY="192.168.3.100"
DNS1=8.8.8.8
ONBOOT="yes"
TYPE="Bridge"
NM_CONTROLLED="no"
" > /etc/sysconfig/network-scripts/ifcfg-br1;
echo "
DEVICE=eno16777736
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
NM_CONTROLLED=no
BRIDGE=br1
" > /etc/sysconfig/network-scripts/ifcfg-eno16777736;
systemctl restart network.service; service network status&& ifconfig
	   ;;
"Install KVM ${opts[7]}")
yum install qemu-kvm qemu-img virt-manager libvirt libvirt-python libvirt-client virt-install virt-viewer system-config-kickstart
      ;;
"Create Virtual Machine V1 ${opts[8]}")
systemctl status vsftpd&& systemctl start vsftpd&& cp /root/Desktop/ks.cfg /var/ftp/pub/&& ksvalidator /var/ftp/pub/ks.cfg&& virt-install --name=project-test --ram=3069 --vcpus=1 --autostart --os-type=linux --extra-args='ks=ftp://192.168.3.60/pub/ks.cfg ksdevice=ens3 ip=192.168.3.21 netmask=255.255.255.0 gateway=192.168.3.100 dns=8.8.8.8' --disk path=/var/lib/libvirt/images/virtuald1.dsk,size=10 --location=/var/lib/libvirt/7.4.iso --network bridge=br1
      ;;
# Case 6 , to quit from menu

"Quit ${opts[9]}")
        break
            ;;
# this case to notify user , if enter invalid options
*) echo invalid option;;
    esac
done

