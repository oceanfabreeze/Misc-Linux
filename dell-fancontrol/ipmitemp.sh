#!/bin/bash
# -------------------------------------------------------------------------
#author=Thomas A. Fabrizio (TF054451)
#verison=1.0
#Changelog= First commit.
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

# This variable sends a IPMI command to get the ambient temp, and outputs it.
TEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)


if [[ $TEMP > $MAXTEMP ]];
    then
        printf "\nWARNING: Temperature is too high! Activating dynamic fan control! ($TEMP C)" >> temperaturealerts.log
        ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x01
    else
        printf "\nTemperature is OK ($TEMP C)" >> temperaturealerts.log
fi

if [[ $TEMP < $MAXTEMP ]];
    then
        printf "\nALERT: Temperature has been restored to safe levels. ($TEMP C)" >> temperaturealerts.log
        ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
        ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x12
    else
        printf "\nTemperature is still too high! ($TEMP C)" >> temperaturealerts.log
fi