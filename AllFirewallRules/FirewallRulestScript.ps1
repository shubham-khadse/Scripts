
# This script checks the firewall rules on ESXi hosts and generates a report in a CSV file

# Get all ESXi hosts and loop through them
Get-VMHost -PipelineVariable esx | ForEach-Object -Process {
    # Get an instance of esxcli for the current ESXi host
    $esxcli = Get-EsxCli -VMHost $esx -V2
    
    # List all the firewall rules for the ESXi host
    $esxcli.network.firewall.ruleset.rule.list.Invoke() |
    Select-Object @{
        Name = 'VMHost'
        Expression = {$esx.Name}
    },
    RuleSet,
    @{
        Name = 'Enabled'
        Expression = {
            # Get the Enabled status for the ruleset
            $esxcli.network.firewall.ruleset.list.Invoke(@{rulesetid = $($_.Ruleset)}).Enabled
        }
    },
    Direction,
    Protocol,
    PortBegin,
    PortEnd,
    PortType
} | Export-Csv -Path ESXi_Firewall_Report.csv -NoTypeInformation -UseCulture
