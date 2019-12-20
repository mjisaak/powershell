<#
.Synopsis
   Restrict the access of an Azure Web App to another Web App.
.EXAMPLE
   Set-AccessRestrictionToAnotherWebApp.ps1 `
    -SourceResourceGroupName 'my-source-rg' `
    -SourceWebAppName
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
ForEach-Object {
    az webapp config access-restriction add -g chacra-t-rg01 -n chacra-t-afunc-ingest --rule-name "ip_$($_)" --action Allow --ip-address "$($_)/32" -p $Priority
}