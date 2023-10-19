# Prompt the user to input vCenter server IPs
$vCenterServers = @()
do {
    $vCenterServer = Read-Host "Enter a vCenter server IP (or leave empty to finish)"
    if ($vCenterServer -ne "") {
        $vCenterServers += $vCenterServer
    }
} while ($vCenterServer -ne "")

# Define the username and password
$UserName = Read-Host "Enter your username"
$YourPassword = Read-Host "Enter your password"

# Prompt for the new ESXi root password
$cred = Get-Credential -UserName "root" -Message "Enter the new ESXi root password"

# Loop through each vCenter server
foreach ($vCenterServer in $vCenterServers) {
    Write-Host "Connecting to $vCenterServer..."

    # Connect to the current vCenter server
    Connect-VIServer -Server $vCenterServer -User $UserName -Password $YourPassword

    # Import the list of ESXi hosts from password.csv
    $esxihostlist = Import-Csv -Path "Hostname.csv"
    $esxihostnames = $esxihostlist.Name

    # Loop through the ESXi hosts and change the root password
    foreach ($esxihostname in $esxihostnames) {
        $esxcli = Get-EsxCli -VMHost $esxihostname -V2

        $passwordInfo = @{
            id = "root"
            password = $cred.GetNetworkCredential().Password
            passwordconfirmation = $cred.GetNetworkCredential().Password
        }

        $esxcli.system.account.set.Invoke($passwordInfo)
    }

    Write-Host "Disconnecting from $vCenterServer..."

    # Disconnect from the current vCenter server
    Disconnect-VIServer -Server $vCenterServer -Confirm:$false
    
}
