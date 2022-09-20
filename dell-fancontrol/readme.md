# dell-fancontrol
My R610 is super loud at normal dynamic fan speeds. After doing a little research on reddit on how the ipmitool works, I decided to write a script to check the ambient chassis temp and if its higher than the variable in the script it sends a command to restore dynamic control to the iDRAC. If dynamic control is enabled and the threshold drops below the max temp variable, it restores the original fan speed set in the script. 

I'm running this script in cron on an RHEL 8 VM on ESXi 7.0 (on my R720 Server), but it should be able to run as long as you have ipmitools.

I run the script via CRON every 5 minutes.

`*/5 * * * * /bin/bash /path/to/script/ipmitemp.sh > /dev/null 2>&1`

I eventually wanna enhance the script to send notifications to my discord channel so that I can see when things get toasty on my phone. 

**Disclaimer**

I'm really not all that great at bash or IPMI. If you decide to implement this in your lab, please heed this warning. 