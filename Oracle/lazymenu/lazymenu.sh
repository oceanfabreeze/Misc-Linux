#!/bin/bash
# -------------------------------------------------------------------------
#author=Thomas A. Fabrizio (TF054451)
#verison=1.4
#Changelog= Added domain downtime, comments to explain what code does.
#Credits= Got the Idea from techbrown blog. Plan to enhance for Cerner BE tasks.
# -------------------------------------------------------------------------
#menu script to perform simple tasks as a BE SE.

# Purpose: Display prompt for program pause
# $1-> Message (optional)
function pause(){
local message="$@"
[ -z $message ] && message="Press [Enter] key to continue..."
read -p "$message" readEnterKey
}

# Purpose - Display the main menu.
function show_menu(){
date
echo "---------------------------"
echo " Main Menu"
echo "---------------------------"
echo "1. Operating System Information"
echo "2. Host Information"
echo "3. Network Information"
echo "4. Currently connected sessions"
echo "5. Login Audit"
echo "6. Memory Information"
echo "7. Filesystem Usage"
echo "8. Process Usage"
echo "9. User Operations"
echo "10. File Operations"
echo "11. Downtime Tasks"
echo "12. Exit"
}

# Purpose - Function for headers
# $1 - message
function write_header(){
local h="$@"
echo "---------------------------------------------------------------"
echo " ${h}"
echo "---------------------------------------------------------------"
}

# Purpose - Get info about the current operating system
function os_info(){
write_header " System Information "
local lversion=$(cat /etc/os-release | grep -E 'ORACLE_SUPPORT_PRODUCT_VERSION' | cut -d'=' -f2 | awk 'FNR == 1 {print}' )
local ltype=$(cat /etc/os-release | grep -E 'ORACLE_SUPPORT_PRODUCT' | cut -d'=' -f2 | awk 'FNR == 1 {print}' )
#echo $output
echo "Linux Distro= $ltype "
echo "Linux Version= $lversion "
#pause "Press [Enter] key to continue..."
pause
}

# Purpose - Get info about server such hostname, domain, FQDN, and Primary IP
function host_info(){
write_header " Host Information "
echo "Hostname : $(hostname -s)"
echo "Domain : $(hostname -d)"
echo "Fully qualified domain name : $(hostname -f)"
echo "Network address (IP) : $(hostname -i)"
pause
}

# Purpose - Network inferface and routing info
function net_info(){
devices=$(netstat -i | cut -d" " -f1 | egrep -v "^Kernel|Iface|lo")
write_header " Network information "
echo "Total network interfaces found : $(wc -w <<<${devices})"

echo "*** IP Addresses Information ***"
ip -4 address show

echo "***********************"
echo "*** Network routing ***"
echo "***********************"
netstat -nr

echo "**************************************"
echo "*** Interface traffic information ***"
echo "**************************************"
netstat -i

pause
}

# Purpose - Display a list of current connections to the node
function user_info(){
local cmd="$1"
case "$cmd" in
who) write_header " Current Connections "; who -H; pause ;;
last) write_header " Login Audit Log "; last ; pause ;;
esac
}

# Purpose - Display used and free memory info
function mem_info(){
write_header " Free and used memory "
free -ht

echo "***********************************"
echo "*** Top 5 memory eating process ***"
echo "***********************************"
ps auxf | sort -nr -k 4 | head -5
pause
}

# Purpose - Get Filesytem Usage Information
function disk_info() {
write_header " Filesystem Information"
df -HP | grep -vE 'tmpfs'
pause
}

#Purpose - Process usage Information

function proc_info() {
write_header " Process Usage Info"
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)
COLUMNS=$(tput cols)

center() {
	w=$(( $COLUMNS / 2 - 20 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

centerwide() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

while :
do

clear

echo ""
echo ""
echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
echo ""
echo "1.  Show all processes" | center
echo "2.  Kill a process" | center
echo "3.  Bring up top" | center
echo "4.  ${txtpur}Exit Program${txtrst}" | center
echo ""

read processmenuchoice
case $processmenuchoice in

1 )
	clear && echo "" && echo "${txtcyn}(Instructions: press ENTER or use arrow keys to scroll list, use /(searchterm) to search, press Q to return to menu. Press ENTER to continue.)${txtrst}" | centerwide && read
	ps -ef | less
;;

2 )
	clear && echo "" && echo "Please enter the PID of the process you would like to kill:" | centerwide
	read pidtokill
	kill -2 $pidtokill && echo "${txtgrn}Process terminated successfully.${txtrst}" | center || echo "${txtred}Process failed to terminate. Please check the PID and try again.${txtrst}" | centerwide
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center && read
;;

3 )
	top
;;

4 )
	clear && echo "" && echo "Are you sure you want to exit? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
	read exitays
	case $exitays in
		y | Y )
			clear && exit
		;;
		n | N )
			clear && echo "" && echo "Okay. Nevermind then." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
		;;
		* )
			clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
	esac
;;


* )
	clear && echo "" && echo "${txtred}Please make a valid selection." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
;;
esac

done
pause
}

#Purpose - Launches user operations menu and child actions
function user_infos() {

write_header "User Operations"

txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)
COLUMNS=$(tput cols)

center() {
	w=$(( $COLUMNS / 2 - 20 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

centerwide() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

while :
do

clear

echo ""
echo ""
echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
echo ""
echo "1.  Create a user" | center
echo "2.  Add a domain to a user" | center
echo "3.  Delete a user" | center
echo "4.  Change a password" | center
echo "5.  ${txtpur}Exit Program${txtrst}" | center
echo ""

read usermenuchoice
case $usermenuchoice in

1 )
	clear && echo "" && echo "Please enter the new username below:  ${txtcyn}(NO SPACES OR SPECIAL CHARACTERS!)${txtrst}" | centerwide && echo ""
	read newusername
	echo "" && echo "Please enter a domain for the new user:  ${txtcyn}(MUST BE LOWERCASE! STILL NO SPACES OR SPECIAL CHARACTERS!)${txtrst}" | centerwide && echo ""
	read newusergroup
	echo "" && echo "What is the new user's full name?  ${txtcyn}(YOU CAN USE SPACES HERE IF YOU WANT!)${txtrst}" | centerwide && echo ""
	read newuserfullname
  echo "" && echo "What is the new users temporary password?" | centerwide && echo ""
  read newusertemppass
	echo "" && echo ""
	groupadd $newusergroup
	useradd -c "$newuserfullname" -m -d /home/$newusername -g d_$newusergroup -s /usr/bin/ksh $newusername && echo "$newusername:$newusertemppass" | chpasswd && chage -d 0 $newusername | echo "${txtgrn}New user $newusername created successfully.${txtrst}" | center || echo "${txtred}Could not create new user.${txtrst}" | center
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center
	read
;;

2 )
	clear && echo "" && echo "Which user needs to be added to a domain? ${txtcyn}(USER MUST EXIST!)${txtrst}" | centerwide && echo ""
	read usermoduser
	echo "" && echo "What should domain are we adding?  ${txtcyn}(MUST BE LOWERCASE! NO SPACES OR SPECIAL CHARACTERS!)${txtrst}" | centerwide && echo ""
	read usermodgroup
	echo "" && echo ""
	usermod -g d_$usermodgroup $usermoduser && echo "${txtgrn}User $usermoduser added to group $usermodgroup successfully.${txtrst}" | center || echo "${txtred}Could not add user to group. Please check if user exists.${txtrst}" | centerwide
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center
	read
;;

3 )
	clear && echo "" && echo "Please enter the username to be deleted below:  ${txtcyn}(THIS CANNOT BE UNDONE!)${txtrst}" | centerwide && echo ""
	read deletethisuser
	echo "" && echo "${txtred}ARE YOU ABSOLUTELY SURE YOU WANT TO DELETE THIS USER? SERIOUSLY, THIS CANNOT BE UNDONE! ${txtcyn}y/n${txtrst}" | centerwide
	read deleteuserays
	echo "" && echo ""
	case $deleteuserays in
		y | Y )
			userdel $deletethisuser && echo "${txtgrn}User $deletethisuser deleted successfully." | center || echo "${txtred}Failed to delete user. Please check username and try again.${txtrst}" | centerwide
		;;
		n | N )
			echo "Okay. Nevermind then." | center
		;;
		* )
			echo "${txtred}Please make a valid selection.${txtrst}" | center
		;;
	esac
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center
	read
;;

4 )
	clear && echo "" && echo "Which user's password should be changed?" | centerwide
	read passuser
	echo ""
	passwd $passuser && echo "${txtgrn}Password for $passuser changed successfully.${txtrst}" | center || echo "${txtred}Failed to change password.${txtrst}" | center
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center
	read
;;

5 )
	clear && echo "" && echo "Are you sure you want to exit? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
	read exitays
	case $exitays in
		y | Y )
			clear && exit
		;;
		n | N )
			clear && echo "" && echo "Okay. Nevermind then." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
		;;
		* )
			clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
		;;
	esac
;;

* )
	clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
;;

esac

done
pause
}

#Purpose  - Launches file operations menu and children
function file_info() {
write_header "File Operations"
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)
COLUMNS=$(tput cols)

center() {
	w=$(( $COLUMNS / 2 - 20 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

centerwide() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

while :
do

clear

echo ""
echo ""
echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
echo ""
echo "1.  Create a directory" | center
echo "2.  Delete a directory" | center
echo "3.  Change ownership of a file" | center
echo "4.  Change permissions on a file" | center
echo "5.  Compress a file" | center
echo "6. Decompress a file" | center
echo "7. ${txtpur}Exit Program${txtrst}" | center
echo ""

read mainmenuchoice
case $mainmenuchoice in


1 )
	clear && echo "" && echo "Current working directory:" | center && pwd | center && echo "" && ls && echo ""
	echo "Please enter the ${txtcyn}full path${txtrst} for the directory to be created:" | centerwide && echo ""
	read mkdirdir
	echo "" && echo ""
	mkdir $mkdirdir && echo "${txtgrn}Directory $mkdirdir created successfully.${txtrst}" | centerwide || echo "${txtred}Failed to create directory.${txtrst}" | center
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center && read
;;

2 )
	clear && echo "" && echo "Current working directory:" | center && pwd | center && echo "" && ls && echo ""
	echo "Please enter the ${txtcyn}full path${txtrst} for the directory to be removed:  ${txtcyn}(MUST BE EMPTY!)${txtrst}" | centerwide && echo ""
	read rmdirdir
	echo "" && echo ""
	rmdir $rmdirdir && echo "${txtgrn}Directory $rmdirdir removed successfully.${txtrst}" | centerwide || echo "${txtred}Failed to remove directory. Please ensure directory is empty.${txtrst}" | centerwide
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center && read
;;

3 )
	clear && echo "" && echo "Which file's ownership should be changed?  ${txtcyn}(MUST EXIST, USE FULL PATH!)${txtrst}" | centerwide && echo ""
	read chownfile
	echo "" && echo "Please enter the username for the new owner of $chownfile:  ${txtcyn}(USER MUST EXIST)${txtrst}" | centerwide && echo ""
	read chownuser
	echo "" && echo "Please enter the new group for $chownfile:  ${txtcyn}(GROUP MUST EXIST)${txtrst}" | centerwide && echo ""
	read chowngroup
	echo "" && echo ""
	chown $chownuser.$chowngroup $chownfile && echo "${txtgrn}Ownership of $chownfile changed successfully.${txtrst}" | centerwide || echo "${txtred}Failed to change ownership. Please check if user, group and file exist.${txtrst}" | center
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center && read
;;

4 )
	clear && echo "" && echo "Which file's permissions should be changed?  ${txtcyn}(MUST EXIST, USE FULL PATH!)${txtrst}" | centerwide && echo ""
	read chmodfile
	echo "" && echo "Please enter the three-digit numeric string for the permissions you would like to set:" | centerwide
	echo ""
	echo "${txtcyn}( format is [owner][group][all]  |  ex: ${txtrst}777${txtcyn} for full control for everyone )${txtrst}" | centerwide
	echo ""
	echo "${txtcyn}4 = read${txtrst}" | center
	echo "${txtcyn}2 = write${txtrst}" | center
	echo "${txtcyn}1 = execute${txtrst}" | center
	echo ""
	read chmodnum
	echo "" && echo ""
	chmod $chmodnum $chmodfile && echo "${txtgrn}Permissions for $chmodfile changed successfully.${txtrst}" | centerwide || echo "${txtred}Failed to set permissions.${txtrst}" | center
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center && read
;;


5 )
	clear && echo "" && echo "Please enter the ${txtcyn}full path${txtrst} and filename for the file you wish to compress:" | centerwide && echo ""
	read pressfile
	echo "" && echo "Which method of compression would you like to use?" | centerwide && echo ""
	echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
	echo ""
	echo "1. gzip" | center
	echo "2. bzip2" | center
	echo "3. compress" | center
	echo ""
	read pressmethod
	echo ""
	case $pressmethod in
		1 )
			gzip $pressfile && echo "${txtgrn}File compressed successfully.${txtrst}" | center || echo "${txtred}File failed to compress.${txtrst}" | center
		;;

		2 )
			bzip2 $pressfile && echo "${txtgrn}File compressed successfully.${txtrst}" | center || echo "${txtred}File failed to compress.${txtrst}" | center
		;;

		3 )
			compress $pressfile && echo "${txtgrn}File compressed successfully.${txtrst}" | center || echo "${txtred}File failed to compress.${txtrst}" | center
		;;

		* )
			echo "${txtred}Please make a valid selection.${txtrst}" | center
		;;
	esac
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center && read
;;

6 )
	clear && echo "" && echo "Please enter the ${txtcyn}full path${txtrst} and filename for the file you wish to decompress:" | centerwide && echo ""
	read depressfile
	case $depressfile in
		*.gz | *.GZ )
			gunzip $depressfiles && echo "${txtgrn}File decompressed successfully.${txtrst}" | center || echo "${txtred}File failed to decompress.${txtrst}" | center
		;;

		*.bz2 | *.BZ2 )
			bunzip2 $depressfile && echo "${txtgrn}File decompressed successfully.${txtrst}" | center || echo "${txtred}File failed to decompress.${txtrst}" | center
		;;

		*.z | *.Z )
			uncompress $depressfile && echo "${txtgrn}File decompressed successfully.${txtrst}" | center || echo "${txtred}File failed to decompress.${txtrst}" | center
		;;

		* )
			echo "${txtred}File does not appear to use a valid compression method (gzip, bzip2, or compress). Please decompress manually.${txtrst}" | centerwide
	esac
	echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center && read
;;

7 )
	clear && echo "" && echo "Are you sure you want to exit? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
	read exitays
	case $exitays in
		y | Y )
			clear && exit
		;;
		n | N )
			clear && echo "" && echo "Okay. Nevermind then." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
		;;
		* )
			clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
	esac
;;

* )
	clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
;;

esac

done
pause
}

#Purpose - Downtime tasks for millenium related services.
function dtime_tasks() {

write_header "Downtime Tasks"

txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)
COLUMNS=$(tput cols)

center() {
	w=$(( $COLUMNS / 2 - 20 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

centerwide() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

while :
do

clear
# Start of downtime tasks menu
echo ""
echo ""
echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
echo ""
echo "1.  IBM MQ Tasks" | center
echo "2.  Domain Tasks" | center
echo "3.  Registry Tasks" | center
echo "4.  Code Tasks" | center
echo "5.  ${txtpur}Exit Program${txtrst}" | center
echo ""

read usermenuchoice
case $usermenuchoice in
#MQ menu start
  1 )
  echo ""
  echo ""
  echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
  echo ""
  echo "1.  Start MQ" | center
  echo "2.  Stop MQ" | center
  echo "3.  ${txtpur}Exit Program${txtrst}" | center
  echo ""

  read mqmenuchoice
  case $mqmenuchoice in
    1 )
    $cer_mgr/mq_$(echo `hostname` | cut -d'.' -f1 | tr '[:upper:]' '[:lower:]')_$(echo $environment | tr '[:upper:]' '[:lower:]')_startup.ksh
    ;;

    2 )
    $cer_mgr/mq_$(echo `hostname` | cut -d'.' -f1 | tr '[:upper:]' '[:lower:]')_$(echo $environment | tr '[:upper:]' '[:lower:]')_shutdown.ksh
    ;;

    3)
    clear && echo "" && echo "Are you sure you want to exit? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
  	read exitays
  	case $exitays in
  		y | Y )
  			clear && exit
  		;;
  		n | N )
  			clear && echo "" && echo "Okay. Nevermind then." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
      esac
  		;;
      * )
      	clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
      ;;


  esac
    ;;
#Domain Menu start
    2 )
    echo ""
    echo ""
    echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
    echo ""
    echo "1.  Start Domain" | center
    echo "2.  Stop Domain" | center
    echo "3.  ${txtpur}Exit Program${txtrst}" | center
    echo ""

    read domainmenuchoice
    case $domainmenuchoice in
      1 )
      echo "${txtcyn}What domain? (LOWERCASE LETTER AND NUMBER ex: p123 )${txtrst}" | centerwide
      read inputdomain
      $cer_mgr_exe/start_cerner_500 -env $inputdomain -domain $inputdomain -verbose
      ;;

      2 )
      echo "${txtcyn}What domain? (LOWERCASE LETTER AND NUMBER ex: p123 )${txtrst}" | centerwide
      read inputdomain
      $cer_proc/terminate_cmb.ksh $inputdomain 0 Y N
      ;;

      3)
      clear && echo "" && echo "Are you sure you want to exit? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
    	read exitays
    	case $exitays in
    		y | Y )
    			clear && exit
    		;;
    		n | N )
    			clear && echo "" && echo "Okay. Nevermind then." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
        esac
    		;;
        * )
        	clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
        ;;
      esac
      ;;
#Registy menu start
    3 )
    echo ""
    echo ""
    echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
    echo ""
    echo "1.  Start Registry Server" | center
    echo "2.  Stop Registry Server" | center
    echo "3.  ${txtpur}Exit Program${txtrst}" | center
    echo ""

    read registrymenuchoice
    case $registrymenuchoice in
      1 )
      $cer_mgr_exe/reg_server -start $cer_reg/registry.cfg
      ;;
      2 )
      $cer_mgr_exe/reg_server -stop
      ;;

      3)
      clear && echo "" && echo "Are you sure you want to exit? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
      read exitays
      case $exitays in
        y | Y )
          clear && exit
        ;;
        n | N )
          clear && echo "" && echo "Okay. Nevermind then." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
        esac
        ;;
        * )
          clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
        ;;
      esac
      ;;
#Code menu start
    4 )
  echo ""
  echo ""
  echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
  echo ""
  echo "1.  Build Code" | center
  echo "2.  Destroy Code" | center
  echo "3.  ${txtpur}Exit Program${txtrst}" | center
  echo ""

  read codemenuchoice
  case $codemenuchoice in
    1 )
    code -build
    ;;

    2 )
    code -destroy
    ;;

    3)
    clear && echo "" && echo "Are you sure you want to exit? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
    read exitays
    case $exitays in
      y | Y )
        clear && exit
      ;;
      n | N )
        clear && echo "" && echo "Okay. Nevermind then." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
      esac
      ;;
      * )
        clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
      ;;
    esac
    ;;
#Exit the menu
    5 )
    	clear && echo "" && echo "Are you sure you want to exit? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
    	read exitays
    	case $exitays in
    		y | Y )
    			clear && exit
    		;;
    		n | N )
    			clear && echo "" && echo "Okay. Nevermind then." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
    		;;
    		* )
    			clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
    	esac
    ;;

    * )
    	clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
    ;;


  esac

  done
  pause
  }

# Purpose - Get input via the keyboard and make a decision using case..esac
function read_input(){
local c
read -p "Enter your choice [ 1 -11 ] " c
case $c in
1) os_info ;;
2) host_info ;;
3) net_info ;;
4) user_info "who" ;;
5) user_info "last" ;;
6) mem_info ;;
7) disk_info ;;
8) proc_info ;;
9) user_infos ;;
10) file_info ;;
11) dtime_tasks ;;
12) echo "Bye!"; exit 0 ;;
*)
echo "Please select between 1 to 12 choice only."
pause
esac
}

# ignore CTRL+C, CTRL+Z and quit singles using trap
trap '' SIGINT SIGQUIT SIGTSTP

# main logic
while true
do
clear
show_menu # display memu
read_input # wait for user input
done
