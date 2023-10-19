#!/bin/ash

# Check Serial Number
esxcfg-info | grep -m 1 "Serial Number"

# Display Hostname
hostname

# Define the expected VMware build version
expected_build="VMware ESXi 7.0.3 build-20842708"

# Check VMware build version
var=$(vmware -lv | grep build)

if [ "$var" == "$expected_build" ] ; then
    echo "VMware build version is correct: $var"
else
    # Remove specific VIBs
    esxcli software vib remove -n qedi
    esxcli software vib remove -n qedf

    # Change directory to datastore1
    cd /vmfs/volumes/datastore1/

    # List files in datastore1 (optional)
    ls

    # Install the specific patch zip
    # Change as per your patch zip name VMware-ESXi-7.OU31-20842708-depot.zip 
    esxcli software vib install -d /vmfs/volumes/datastore1/VMware-ESXi-7.OU31-20842708-depot.zip

    # Reboot the host
    reboot
fi
