#!/usr/bin/env bash
# Install google authenticator and configuring it for two factor authenticator in linux OS
dist=`hostnamectl | grep Operating | awk '{print $3}'`
ssh_pam_path="/etc/pam.d/sshd"
# Check user access
if [ `whoami` != "root" ]
then
	echo "Error: Please run this script with sudo access or root privilege...!!"
	exit 1
fi
# Check Distro OS and update package 
os_detection(){
case $dist in
	Ubuntu)
		apt-get update -y
		apt-get install -y libpam-google-authenticator
		;;
	Debian)
		apt-get update -y
                apt-get install -y libpam-google-authenticator
                ;;
	CentOS)
		yum update -y 
		yum install -y  https://dl.fedoraproject.org/pub/epel/epel-release-latest-`hostnamectl | grep Operating | awk '{print $5}'`.noarch.rpm
		yum install -y google-authenticator 
		;;
	     *)
		echo "Error: This script is'nt properly for "$dist""
		exit 1
esac

}
## run Google authenticator and configuration
run_google_auth(){
	google-authenticator
	if [ "$?" == "0" ] 
	then
		echo "auth required pam_google_authenticator.so nullok" >> "$ssh_pam_path"
	else
		echo "Error: somthing wrong!\nPlease recheck steps..."

	fi
}
os_detection
run_google_auth



