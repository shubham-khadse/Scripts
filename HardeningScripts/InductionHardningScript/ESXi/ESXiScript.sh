#!/bin/bash

# Adding HostName
esxcfg-info | grep -m 1 "Serial Number"
esxcli network ip interface ipv4 get grep vmk0

echo "------------------------------"
# echo "Please Enter the hostname:
# read serverHostname
# esxcli system hostname set --host="$serverHostname"

echo "------------------------------"

hostname

# Adding Banner
echo "===============Addig Banner==============="
echo " \"This is an YOUR_ORGANATION_NAME computer system. This computer system, including all related equipment, networks and network devices (specifically including Internet access), are provided only for authorized use. YOUR_ORGANATION_NAME systems may be monitored for all lawful purposes, to ensure that their use is authorized, for management of the system, to facilitate protection against unauthorized access, and to verify security procedures, survivability and operational security. Monitoring includes active attacks by authorized YOUR_ORGANATION_NAME entities to test or verify the security of this system. During monitoring, information may be examined, recorded, copied, and used for authorized purposes. All information, including personal information, placed on or sent over this system, may be monitored. Use of this YOUR_ORGANATION_NAME computer system, authorized or unauthorized, constitutes consent to monitoring of this system. Unauthorized use may subject you to criminal prosecution. Evidence of unauthorized use collected during monitoring may be used for administrative, criminal, or adverse action.\" " > /etc/issue

# Print Banner Output
cat /etc/issue

echo ""
echo "------------------------------"
echo ""

echo "===============Adding Alias==============="

# Prompt the user for the OS type
echo "Please enter type of OS: Type 1 or 2
1] ESXi
2] ESXi-AOS"
read osType

if [ "$osType" == 1 ]; then
    # For ESXi
    echo "Adding text to profile.local file:"
    
    # Check if the 'alias rm' line exists in /etc/profile.local
    ali="$(grep -c 'alias rm' /etc/profile.local)"

    if [ "$ali" == 0 ]; then
        # Add the 'alias rm' line to /etc/profile.local
        sed -i "1i alias rm='rm -i'" /etc/profile.local
        cat /etc/profile.local
    else
        cat /etc/profile.local
    fi

    echo "------------------------------"

    echo "Adding text to local.sh file:"
    
    # Check if the 'alias rm' line exists in /etc/rc.local.d/local.sh
    var="$(grep -c 'alias rm' /etc/rc.local.d/local.sh)"

    if [ "$var" == 0 ]; then
        # Add the 'alias rm' line to /etc/rc.local.d/local.sh
        sed -i "1i alias rm='rm -i'" /etc/rc.local.d/local.sh
        cat /etc/rc.local.d/local.sh
    else
        cat /etc/rc.local.d/local.sh
    fi
else
    # For ESXi AOS 
    echo "Adding text to profile.local file:"
    
    # Check if the 'alias rm' line exists in /etc/profile.local
    ali="$(grep -c 'alias rm' /etc/profile.local)"

    if [ "$ali" == 0 ]; then
        # Add the 'alias rm' line to /etc/profile.local
        sed -i "1i alias rm='rm -i'" /etc/profile.local
        cat /etc/profile.local
    else
        cat /etc/profile.local
    fi
fi

echo ""
echo "------------------------------"
echo ""

echo "===============NTP and DNS Setup==============="

# echo "Enter the server location (1 for PROD, 2 for DR, 3 for NDR) for NTP and DNS:"
echo "Enter the server location : Type 1 or 2 or 3
1] PROD
2] DR
3] NDR"
read serverLocation
if [ "$serverLocation" == 1]
then
    echo "----NTP----"
    esxcli system ntp set -s=0.0.0.0 -s=0.0.0.0 -s=0.0.0.0
    cat /etc/ntp/conf

     echo "----DNS----"
     echo "nameserver 0.0.0.0
nameserver 0.0.0.0
search YourOrganationName.COM" > /etc/resolve.conf
     cat /etc/resolv.conf
elseif [ "$serverLocation" == 2]
then
    echo "----NTP----"
    esxcli system ntp set -s=0.0.0.0 -s=0.0.0.0 -s=0.0.0.0
    cat /etc/ntp/conf

     echo "----DNS----"
     echo "nameserver 0.0.0.0
nameserver 0.0.0.0
search YourOrganationName.COM" > /etc/resolve.conf
     cat /etc/resolv.conf
elseif [ "$serverLocation" == 3]
then
    echo "----NTP----"
    esxcli system ntp set -s=0.0.0.0 -s=0.0.0.0 -s=0.0.0.0
    cat /etc/ntp/conf

     echo "----DNS----"
     echo "nameserver 0.0.0.0
nameserver 0.0.0.0
search YourOrganationName.COM" > /etc/resolve.conf
     cat /etc/resolv.conf
elseif [ "$serverLocation" == 4]
then
    echo "----NTP----"
    esxcli system ntp set -s=0.0.0.0 -s=0.0.0.0 -s=0.0.0.0
    cat /etc/ntp/conf

     echo "----DNS----"
     echo "nameserver 0.0.0.0
nameserver 0.0.0.0
search YourOrganationName.COM" > /etc/resolve.conf
     cat /etc/resolv.conf
else 
    echo "Please Enter the Valid Input"
fi

esxcli system ntp set -e=yes

echo ""
echo "------------------------------"
echo ""   

echo "===============Remote loggin for ESXi host (system syslog)==============="

echo "Enter the zone for remote login : Type 1 or 2
1] CROP
2] DMZ"
read serverZone
if [ "$serverZone" == "1" ]
then
    esxcli system syslog config set --loghost='udp://0.0.0.0'
    esxcli system syslog reload
    echo "Syslog config succeeded upd://0.0.0.0"
elif [ "$serverZone" == "2"]
then
    echo $serverLocation
    if[ "$serverLocation" == "1"]
    then
        esxcli system syslog config set --loghost='tcp://0.0.0.0,tcp://0.0.0.0'
        esxcli system syslog reload
        echo "Syslog config succeeded tcp://0.0.0.0,tcp://0.0.0.0"
    elif[ "$serverLocation" == "2"]
    then 
        esxcli system syslog config set --loghost='tcp://0.0.0.0,tcp://0.0.0.0'
        esxcli system syslog reload
        echo "Syslog config succeeded tcp://0.0.0.0,tcp://0.0.0.0"
    elif[ "$serverLocation" == "3"]
    then 
        esxcli system syslog config set --loghost='tcp://0.0.0.0,tcp://0.0.0.0'
        esxcli system syslog reload
        echo "Syslog config succeeded tcp://0.0.0.0,tcp://0.0.0.0'"
    else
        echo "Please enter valid location"
    fi

else
    echo "Please enter valid zone option"
fi

echo ""
echo "------------------------------"
echo ""

echo "===============PartnerSupport==============="

esxcli software acceptance get
esxcli software acceptance set --level PartnerSupported

echo ""
echo "------------------------------"
echo ""   

echo "===============Shadow File==============="

sed -i "1s/:0:99999:7:::/:0:365:7:365::/" /etc/shadow
sed -i "1s/:0:99999:7:::/:0:60:7:60::/" /etc/shadow
cat /etc/shadow

echo ""
echo "------------------------------"
echo ""   

echo "===============sshd_config File==============="


echo ""
echo "------------------------------"
echo ""   

echo "===============Advanced==============="

esxcli system setting advanced set -o /UserVars/ESXiShellInteractiveTimeOut -i 600
esxcli system setting advanced list -o /UserVars/ESXiShellInteractiveTimeOut 

vim-cmd hostsvc/advopt/update Security.AccountLockFailures int 3
vim-cmd hostsvc/advopt/update Security.PasswordQualityControl string "retry=3 min=8,8,8,7,6"
sed -i "s/remember=0/remember=10/" /etc/pam.d/passwd
cat  /etc/pam.d/passwd

# vim-cmd hostsvc/advopt/update Security.AccountUnlockTime int 900
# vim-cmd hostsvc/advopt/update Security.PasswordHistory int 10

# Do not set the ESXiShellTimeOut to 600 as it will turn off the SSH service after 10 minutes
# esxcli system setting advanced set -o /UserVars/ESXiShellTimeOut -i 600
# esxcli system setting advanced list -o /UserVars/ESXiShellTimeOut 

echo ""
echo "------------------------------"
echo ""   

echo "===============Firewall Rules==============="

esxcli network firewall ruleset set --enable true --ruleset-id CIMHttpsServer
esxcli network firewall ruleset list | grep 'CIMHttpsServer'  

esxcli network firewall ruleset set --enable true --ruleset-id CIMHttpServer
esxcli network firewall ruleset list | grep 'CIMHttpServer'

esxcli network firewall ruleset set --enable true --ruleset-id ntpClient
esxcli network firewall ruleset list | grep 'ntpClient'

esxcli network firewall ruleset set --enable true --ruleset-id iSCSI
esxcli network firewall ruleset list | grep 'iSCSI'

esxcli network firewall ruleset set --enable true --ruleset-id sshServer
esxcli network firewall ruleset list | grep 'sshServer'

esxcli network firewall ruleset set --enable true --ruleset-id sshClient
esxcli network firewall ruleset list | grep 'sshClient'

esxcli network firewall ruleset set --enable true --ruleset-id CIMSLP
esxcli network firewall ruleset list | grep 'CIMSLP'

echo ""
echo "------------------------------"
echo ""   

echo "===============Service==============="

/etc/init.d/ESXShell status
/etc/init.d/ESXShell stop
/etc/init.d/ESXShell status
echo "------------------------------"
/etc/init.d/ntpd status
/etc/init.d/ntpd start
/etc/init.d/ntpd status
echo "------------------------------"
/etc/init.d/SSH status
/etc/init.d/SSH start
/etc/init.d/SSH status
echo "------------------------------"
/etc/init.d/DCUI status
/etc/init.d/DCUI start
/etc/init.d/DCUI status
echo "------------------------------"
/etc/init.d/slpd status
/etc/init.d/slpd stop
/etc/init.d/slpd status
echo "------------------------------"