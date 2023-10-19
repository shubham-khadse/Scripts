# Connect to the vCenter Server
Connect-VIServer -Server 0.0.0.0

# Connect-VIServer -Server 0.0.0.0 -User UserName -Password YourPassword

# Prompt for the new ESXi root password
$cred = Get-Credential -UserName "root" -Message "Enter the new ESXi root password"

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

# Disconnect from the vCenter Server
Disconnect-VIServer -Server * -Confirm:$false
