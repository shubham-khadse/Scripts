# Connect to the vCenter server
Connect-VIServer -Server 0.0.0.0

# Import a list of ESXi hostnames from the "Hostname.csv" file
$esxiHostList = Import-Csv -Path "Hostname.csv"
$esxiHostnames = $esxiHostList.Name

# Loop through each ESXi host
foreach ($esxiHostname in $esxiHostnames) {
    # Get advanced setting "UserVars.ESXiShellTimeOut" and set it to 0 without confirmation
    Get-AdvancedSetting -Entity $esxiHostname -Name "UserVars.ESXiShellTimeOut" | 
    Set-AdvancedSetting -Value 0 -Confirm:$false
}

# Display the modified settings
Get-VMHost $esxiHostnames | Sort-Object Name | Format-Table -AutoSize

# Restarting SSH
Get-VMHost  $esxiHostname | Get-VMHostService | Where-Object Key -eq "TSM-SSH" | Start-VMHostService | Restart-VMHostService | Set-VMHostService -Policy "On"