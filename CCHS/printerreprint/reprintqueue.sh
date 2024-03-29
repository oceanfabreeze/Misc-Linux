#!/bin/bash
# -------------------------------------------------------------------------
#author=Thomas A. Fabrizio (801210714)
#verison=1.2
#Changelog= 
#4/4/2023: Added Warning Screen to first value. 
#4/6/2023: Fixed bug where if printing user was not SYSTEM, command would error out due to extra characters. 
# -------------------------------------------------------------------------
#Re-print all jobs from a specific printer on node or all printers. 


# Purpose - Display the main menu.

function show_menu(){ #main menu function
date
echo "---------------------------"
echo " Reprint Queue Script"
echo " Version = 1.2 "
echo " Author = Thomas A. Fabrizio (801210714)"
echo "---------------------------"
echo "---------------------------"
echo " Main Menu"
echo "---------------------------"
echo "1. Reprint all queues from this node (ONLY FOR EMERGENCY)"
echo "2. Reprint specific printer."
echo "3. Exit"
}

function pause(){
local message="$@"
[ -z $message ] && message="Press [Enter] key to continue..."
read -p "$message" readEnterKey
}

# Purpose - Get input via the keyboard and make a decision using case..esac
function read_input(){
local c
read -p "Enter your choice: " c
case $c in
1) print_all ;;
2) print_queue ;;
3) echo "Bye!"; exit 0 ;;
*)
echo "Please select between 1 to 3 choice only."
pause
esac
}

function print_all(){
textreset=$(tput sgr0) # reset the foreground colour
red=$(tput setaf 1)
echo "---------------------------"
echo "---------------------------"
tput smul; echo "${red} WARNING! ${textreset}";
tput smul; echo "${red} WARNING! ${textreset}";
tput smul; echo "${red} WARNING! ${textreset}";
tput smul; echo "${red} WARNING! ${textreset}";
tput smul; echo "${red} WARNING! This will reprint all jobs on this node!! Are you sure you want to do this? ${textreset}";
echo "---------------------------"
echo "---------------------------"
echo ""
echo ""
echo ""
echo ""
pause
read -p "Enter the date in mmdd format " date
file=/cerner/d_p0182/print/printfile.log.$date
cat $file|grep '\s\-t\s/cerner/d_p0182/print/'|cut -b 3-5,9-31,31-150|sed 's/-]//g'|sed 's/-U".*"//g' > reprint.csv
    while read line
do
$line
echo $line
done < reprint.csv
pause
}

function print_queue(){
read -p "Enter the date in mmdd format " date
read -p "Enter queue name " queue
file=/cerner/d_p0182/print/printfile.log.$date
echo "Printing from $file for $queue"
cat $file|grep $queue'\s\-t\s/cerner/d_p0182/print/'|cut -b 3-5,9-31,31-150|sed 's/-]//g'|sed 's/-U".*"//g' > reprint.csv
while read line
do
$line
echo $line
done < reprint.csv
pause
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