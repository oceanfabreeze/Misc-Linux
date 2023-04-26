#!/bin/bash
# -------------------------------------------------------------------------
#author=Thomas A. Fabrizio (TAFFY)
#verison=1.0
#Changelog=
# ----------------------------------------------------------------------------------
# Script to check if openvpn is running. If not, start it. 
# ----------------------------------------------------------------------------------
if pgrep openvpn;
    then
        printf "\nVPN IS RUNNING!" >> vpn.log
else
    printf "\nVPN IS NOT RUNNING. STARTING." >> vpn.log
    service openvpn-client@vpn start
fi