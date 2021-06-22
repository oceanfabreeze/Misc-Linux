#!/bin/sh
# Shell script to check filesystem /var/lib/mysql usage on zabbix servers and proxies
# It will send an email to the ZABBIXADMIN, if the (free available) percentage of space is >= $ALERT
#author=Thomas A. Fabrizio (TF054451)
#verison=1.3
# -------------------------------------------------------------------------
#set email for zabbix admin
ZABBIXADMIN="thomas.fabrizio@cerner.com"
# set alert level 85% is default
ALERT=85
df -HP | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | grep mysql | while read output;
do
  #echo $output
  mysqlspace=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  if [ $mysqlspace -ge $ALERT ]; then
    echo "Running out of space for MySQL! \"Currently at ($mysqlspace%)\" on $(hostname) as of $(date). If this is not resolved, Zabbix services will crash for this node." |
     mail -s "Zabbix Stability Alert: Almost out of disk space for MySQL!" $ZABBIXADMIN
  fi
done
