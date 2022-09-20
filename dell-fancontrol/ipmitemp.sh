#!/bin/bash
# -------------------------------------------------------------------------
#author=Thomas A. Fabrizio (TF054451)
#verison=1.1
#Changelog= added some elif and changed the variables
# ----------------------------------------------------------------------------------
# Script for checking the temperature that's reported by the ambient temperature sensor,
# and if it's too high send the raw IPMI command to enable dynamic fan control.
#
# Requires:
# ipmitool – yum install ipmitool
# ----------------------------------------------------------------------------------


# IPMI SETTINGS:
# Input your IPMI credentials here.
# DEFAULT IP: 0.0.0.0
IPMIHOST=0.0.0.0
IPMIUSER=root
IPMIPW=calvin

# TEMPERATURE
# Change this to the temperature in celcius you are comfortable with.
# If the temperature goes above the set degrees it will send raw IPMI command to enable dynamic fan control
MAXTEMP=30
SAFETEMP=29

# This variable sends a IPMI command to get the ambient temp, and outputs it.
TEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)


if [ $TEMP -ge $MAXTEMP ];
    then
        printf "\nWARNING: Temperature is too high! Activating dynamic fan control! ($TEMP C)" >> temperaturealerts.log
        ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x01
elif [ $TEMP -eq $SAFETEMP ]
    then
        printf "\nALERT:Temperature is elevated ($TEMP C)" >> temperaturealerts.log
else
    printf "\nMESSAGE:Temperature is at safe levels. ($TEMP C)" >> temperaturealerts.log
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x12
fi