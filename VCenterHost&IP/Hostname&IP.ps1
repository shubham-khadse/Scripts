# This script connects to a vCenter server, retrieves the IP address of the 'vmk0' network adapter on all ESXi hosts, and appends the results to a CSV file.

# Connect to the vCenter server with the specified IP address
Connect-VIServer -Server 0.0.0.0

# Get all ESXi hosts and their network adapter information
Get-VMHost | Get-VMHostNetworkAdapter | Where-Object Name -eq 'vmk0' |
    Select-Object @{
        Name = 'VMHost'
        Expression = {$_.VMHost.Name}
    },
    Name,
    IP |
    Export-Csv -Path "HostnameAndIp.csv" -NoTypeInformation -Append


    # Anoter Way
    # Get-VMHost | Get-VMHostNetworkAdapter | Where-Object Name -eq vmk0 | Select-Object VMHost, Name, IP | Export-Csv -Path "HostnameAndIp.csv" -NoTypeInformation -Append