# Retrieves vSAN Transport firewall exceptions status from specified ESXi hosts and exports the data to a CSV

#  Set the vCenter Server IP 
Connect-VIServer -Server 0.0.0.0

# Import a list of ESXi hostnames from the CSV file "Hostname.csv"
$esxihostlist = Import-Csv -Path "Hostname.csv"
$esxihostname = $esxihostlist.Name

Get-Cluster -PipelineVariable cluster | Get-VMHost $esxihostname | Get-VMHostFirewallException |
Where-Object Name -EQ "vSAN Transport” | Select-Object @{N='Cluster’ ;E={$cluster.Name}}, Name, VMHost,
Enabled | Export-Csv -Path "RDT_VSanService.csv" -NoTypeInformation -Append


# For all vCenter Hosts, you can uncomment and use the following code and comment the above code

# Get-Cluster -PipelineVariable cluster | Get-VMHost | Get-VMHostFirewallException | Where-Object Name -EQ "vSAN Transport” | Select-Object @{N='Cluster’ ;E={$cluster.Name}}, Name, VMHost, Enabled | Export-Csv -Path "RDT_VSanService.csv" -NoTypeInformation -Append 