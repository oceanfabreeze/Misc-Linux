#!/bin/sh
# Shell script to launch Zabbix cleanup SQL automated.
#author=Thomas A. Fabrizio (TF054451)
#verison=1.0 Alpha
#Changelog= Initial Commit, Alpha
# ---------------------------------------------------------------------------------

(
  function cleanup()
  {
    mysql zabbix < /root/zabbix_cleanup.sql
  }

  function showdate()
  {
    date
  }

  showdate #prints date for logfile
  cleanup #runs cleanup

) 2>&1 | tee /var/log/zabbix/autocleanuplog.out #log stdout