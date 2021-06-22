# bashyboi
Dumb linux crap I write

## zabbixmysqlcheck
Created this to check the MySQL filesystem on Unified Regions Zabbix nodes. If the filesystem gets over the set threshold, it sends an email to the Zabbix Admin defined in the script. I probably could've used Zabbix to do this e-mail notification.....but heck I still haven't gone through the email configuration for our Zabbix instance and most of the email's it sends are completely useless. So I have them filter out to a separate folder and wouldn't see the email about this filesystem needing cleaned up.

To install this as a daily cronjob. Copy script to /etc/cron.daily/ using commands below.

```bash
wget -P /etc/cron.daily https://raw.github.cerner.com/TF054451/bashyboi/master/mysql-filesystem-check/zabbixmysqlcheck
chmod +x /etc/cron.daily/zabbixmysqlcheck

#use vi to edit the $ZABBIXADMIN field in the script to set your own email.
vi /etc/cron.daily/zabbixmysqlcheck
```
## zabbix_cleanup.sql
Created this to cleanup history data from the Zabbix servers and proxies. One of the many flaws of Zabbix is that the housekeeper service sucks. It can only delete so much before it gives up and times out. This SQL will go out and make sure that the retention policy you set is properly followed. Default is 90 day drilled down history, 1 year trends history.
