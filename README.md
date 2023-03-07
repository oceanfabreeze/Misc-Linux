# bashyboi
Dumb linux crap I write in this repo. This specific repo is copied from my corp repo as a backup.

## dell-fancontrol
Created to control fan noise on Dell PowerEdge servers through IPMI. Tests temperature periodically, if temp exeeds limit fan control is returned to default values. 

## mysql-filesystem-check
Created this to check the MySQL filesystem on my Zabbix nodes. If the filesystem gets over the set threshold, it sends an email to the Zabbix Admin defined in the script. I probably could've used Zabbix to do this e-mail notification.....but heck I still haven't gone through the email configuration for our Zabbix instance and most of the email's it sends are completely useless. So I have them filter out to a separate folder and wouldn't see the email about this filesystem needing cleaned up.

To install this as a daily cronjob. Copy script to /etc/cron.daily/ using commands below.

```bash
wget -P /etc/cron.daily https://raw.github.cerner.com/TF054451/bashyboi/master/mysql-filesystem-check/zabbixmysqlcheck
chmod +x /etc/cron.daily/zabbixmysqlcheck

#use vi to edit the $ZABBIXADMIN field in the script to set your own email.
vi /etc/cron.daily/zabbixmysqlcheck
```
## enhanced-zabbix_housekeeping
Created this to cleanup history data from the Zabbix servers and proxies. One of the many flaws of Zabbix is that the housekeeper service stinks sometimes. It can only delete so much before it gives up and times out. Especially with the resources our system has. This SQL will go out and make sure that the retention policy you set is properly followed. Default is 90 day drilled down history, 1 year trends history. Work in progress...plan on testing on my homelab zabbix instance first.

## lazymenu
A menu created to assist newer backend System Engineers with quick tasks. Work in progress....

## union-printer-test
A script created to test backend printers on Appnodes at ChristianaCare. Loads printers from CSV or by user input.
