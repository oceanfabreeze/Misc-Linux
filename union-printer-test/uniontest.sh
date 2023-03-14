#!/bin/bash
# -------------------------------------------------------------------------
#author=Thomas A. Fabrizio (801210714)
#verison=1.0
#Changelog= 
# -------------------------------------------------------------------------
#menu script to test printers from a csv at Union from each node. 
# Purpose - Display the main menu.

function show_menu(){ #main menu function
date
echo "---------------------------"
echo " Printer Test Script"
echo " Version = 1.1"
echo " Author = Thomas A. Fabrizio (801210714)"
echo "---------------------------"
echo "---------------------------"
echo " Main Menu"
echo "---------------------------"
echo "1. Test all printers at Union on current node"
echo "2. Test specific printer."
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
1) print_test ;;
2) print_test_specific ;;
3) echo "Bye!"; exit 0 ;;
*)
echo "Please select between 1 to 3 choice only."
pause
esac
}

function print_test(){
    while read line
do
   echo "Printing test page to : $line"
   lhost=$(hostname)
   lpr -P $line <<< "LEAVE IN TRAY FOR ITSYSMGR. TEST PAGE. Printed to $line from $lhost"
done < unionprinters.csv
pause
}

function print_test_specific(){
read -p "Enter the printername " printerselection
lhost=$(hostname)
lpr -P $printerselection <<< "LEAVE IN TRAY FOR ITSYSMGR. TEST PAGE. Printed to $printerselection from $lhost"
echo "Printed to $printerselection from $lhost"
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