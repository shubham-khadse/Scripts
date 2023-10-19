# This script is for SSH Restart and setting the policy on ESXi hosts based on a CSV file and for all vCenter hosts.

# Import a list of ESXi hostnames from the CSV file "HostnameList.csv"
$esxiHostList = Import-Csv -Path "Hostname.csv"
$esxiHostnames = $esxiHostList.Name

# Loop through each ESXi hostname and manage the TSM-SSH service
$esxiHostnames | ForEach-Object {
    $esxiHostname = $_
    $esxiHost = Get-VMHost -Name $esxiHostname

    # Check if the ESXi host was found
    if ($esxiHost) {
        # Get the TSM-SSH service on the ESXi host
        $tsmService = $esxiHost | Get-VMHostService | Where-Object Key -eq "TSM-SSH"

        # Check if the TSM-SSH service was found
        if ($tsmService) {
            # Start the TSM-SSH service
            Start-VMHostService -HostService $tsmService -Confirm:$false

            # Restart the TSM-SSH service
            Restart-VMHostService -HostService $tsmService -Confirm:$false

            # Set the TSM-SSH service to "On"
            Set-VMHostService -HostService $tsmService -Policy "On" -Confirm:$false

            Write-Host "TSM-SSH service on $esxiHostname has been started, restarted, and set to 'On.'"
        } else {
            Write-Host "TSM-SSH service not found on $esxiHostname."
        }
    } else {
        Write-Host "ESXi host $esxiHostname not found."
    }
}

# For all vCenter hosts, you can uncomment and use the following code and comment the above code
# Get-VMHost | Get-VMHostService | Where-Object Key -eq "TSM-SSH" | Start-VMHostService | Restart-VMHostService | Set-VMHostService -Policy "On"

