#!/bin/sh
# Shell script to launch Zabbix cleanup SQL manually.
#author=Thomas A. Fabrizio (TF054451)
#verison=1.3 Alpha
#changelog= 1.3 Fix script hang when logging stdout is enabled. 
(

  function pause()
  {
    local message="$@"
    [ -z $message ] && message="Press [Enter] key to continue..."
    read -p "$message" readEnterKey
  }

  function cleanup()
  {
    mysql zabbix < /root/zabbix_cleanup.sql
  }

  function confirmmsg()
  {
    echo "Are you sure you want to cleanup the Zabbix Database Y=Yes N=No"
  }

  function read_input()
  {
    local userinput
    read userinput

    case $userinput in
      y) cleanup ;;
      Y) cleanup ;;
      n) echo "Bye!"; exit 0 ;;
      N) echo "Bye!"; exit 0 ;;
      *)
      echo "Please select a valid choice"
      pause
    esac
  }
  
  confirmmsg #displaymessage to user asking if this is actually what they wanna do
  read_input #read user input, Y for yes N for no.

) 2>&1 | tee /var/log/zabbix/cleanuplog.out #log stdout