#!/bin/bash
# -------------------------------------------------------------------------
#author=Thomas A. Fabrizio (801210714)
#verison=1.0
#Changelog= 
# -------------------------------------------------------------------------
#Re-print all jobs from a specific printer on node. 
#cat printfile.log.0402|grep 'lz79\s\-t'| cut -b 3-4,19-31,35-147|sed 's/-]//g'


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
echo "1. Reprint all queues from this node"
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
    while read line
do
   echo "Printing test page to : $line"
   lhost=$(hostname)
   lpr -P $line <<< "LEAVE IN TRAY FOR ITSYSMGR. TEST PAGE. Printed to $line from $lhost"
done < unionprinters.csv
pause
}

function print_queue(){
read -p "Enter the date in mmdd format " date
read -p "Enter queue name " queue
file=/cerner/d_p0182/print/printfile.log.$date
echo "Printing from $file for $queue"
cat $file|grep $queue'\s\-t'| cut -b 3-4,19-31,35-147|sed 's/-]//g' > reprint.csv
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