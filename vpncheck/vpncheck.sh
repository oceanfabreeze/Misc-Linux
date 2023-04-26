#!/bin/bash
# -------------------------------------------------------------------------
#author=Thomas A. Fabrizio (TAFFY)
#verison=1.1
#Changelog=Adding Date to logfile
# ----------------------------------------------------------------------------------
# Script to check if openvpn is running. If not, start it. 
# ----------------------------------------------------------------------------------

DATE=$(date)

if pgrep openvpn;
    then
        printf "\n($DATE) VPN IS RUNNING!" >> vpn.log
else
    printf "\n($DATE) VPN IS NOT RUNNING. STARTING." >> vpn.log
    service openvpn-client@vpn start
fi