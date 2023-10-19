# Define the username and password
username="UserName"
# Set the password for new user
password="YourPassword"

# Check if the user exists
user_exists="$(esxcli system account list | grep $username)"
if [ "$user_exists" == "$username" ]; then
    # If the user exists, display the serial number, hostname, and check for user presence
    esxcfg_info | grep -m 1 "Serial Number"
    hostname
    esxcli system account list | grep $username
    echo
else
    # If the user doesn't exist, add the user, set permissions, and then display the serial number, hostname, and user info
    esxcli system account add -i $username -p $password -c $password
    esxcli system permission set -i $username -r Admin
    esxcfg_info | grep -m 1 "Serial Number"
    hostname
    esxcli system account list | grep $username
fi
