#!/bin/bash
# -------------------------------------------------------------------------
#author=Thomas A. Fabrizio (801210714)
#verison=1.0
#Changelog= 
# -------------------------------------------------------------------------
#Re-print all jobs from a specific printer on node or all printers. 


# Purpose - Display the main menu.

function show_menu(){ #main menu function
date
echo "---------------------------"
echo " Reprint Queue Script"
echo " Version = 1.0"
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
read -p "Enter the date in mmdd format " date
file=/cerner/d_p0182/print/printfile.log.$date
cat $file|grep '\s\-t\s/cerner/d_p0182'| cut -b 3-4,19-31,35-150|sed 's/-]//g' > reprint.csv
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
cat $file|grep $queue'\s\-t\s/cerner/d_p0182'| cut -b 3-4,19-31,35-150|sed 's/-]//g' > reprint.csv
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