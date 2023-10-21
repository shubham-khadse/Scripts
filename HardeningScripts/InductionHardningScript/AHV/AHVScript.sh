#!/bin/bash

# Find the line number for 'soft core' in /etc/security/limits.conf
softCore="$(grep -n -F -w 'soft     core' /etc/security/limits.conf | cut -d : -f 1)"

# Insert the new limit entry before the 'soft core' line
sed -i "$softCore i *           soft    core            0" /etc/security/limits.conf

# Add a space for clarity
echo ""

# Check the attributes of /etc/environment
lsattr /etc/environment

# Set /etc/environment to immutable
chattr +i /etc/environment

# Check the updated attributes of /etc/environment
lsattr /etc/environment

echo ""

# Check for 'audit' related configurations in grub files
cat /etc/grub2.cfg | grep -i audit
cat /etc/grub2-efi.cfg | grep -i audit

# Check for 'password' related configurations in grub files
cat /etc/grub2.cfg | grep -i password
cat /etc/grub2-efi.cfg | grep -i password

echo " "

# Count the occurrences of a specific banner in /etc/motd
banner="$(grep -c 'This is a YourCompanyName computer system' /etc/motd)"

if [ "$banner" == 0 ]; then
    # Add a banner line to /etc/motd if it doesn't exist
    sed -i "1i This is a YourCompanyName computer system." /etc/motd
    cat /etc/motd
else
    cat /etc/motd
fi


echo " "

# Create log files and check their presence
touch /var/log/security
touch /var/log/faillog
touch /var/log/sudo.log

# Check the presence of the newly created log files
cd /var/log/
ls | grep security
ls | grep faillog
ls | grep sudo.log


echo " "
