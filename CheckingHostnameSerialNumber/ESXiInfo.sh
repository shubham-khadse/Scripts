# Retrieve the serial number of the ESXi host
esxcfg_info | grep -m 1 "Serial Number"

# Retrieve the hostname of the ESXi host
hostname

# Get IPv4 interface details for the vmk0 interface
esxcli network ip interface ipv4 get | grep vmk0

# List network interface controllers (NICs) on the ESXi host
esxcli network nic list
