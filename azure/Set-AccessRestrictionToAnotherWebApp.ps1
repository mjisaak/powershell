<#
.Synopsis
   Restrict the access of an Azure Web App to another Web App.
.EXAMPLE
   Set-AccessRestrictionToAnotherWebApp.ps1 `
        -SourceResourceGroupName 'my-source-rg' `
        -SourceWebAppName 'my-source-web-app' `
        -TargetResourceGroupName 'my-target-rg' `
        -TargetWebAppName 'my-target-web-app' `
        -Priority 100
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    $SourceResourceGroupName, 
    
    [Parameter(Mandatory = $true)]
    $SourceWebAppName,

    [Parameter(Mandatory = $true)]
    $TargetResourceGroupName, 
    
    [Parameter(Mandatory = $true)]
    $TargetWebAppName,

    [Parameter(Mandatory = $false)]
    $Priority = 1
)

(az webapp show -g $SourceResourceGroupName -n $SourceWebAppName --query '[possibleOutboundIpAddresses, outboundIpAddresses]' --output tsv) -join ',' -split ',' | 
Get-Unique |
ForEach-Object {
    az webapp config access-restriction add -g $TargetResourceGroupName -n $TargetWebAppName --rule-name "ip_$($_)" --action Allow --ip-address "$($_)/32" -p $Priority
}