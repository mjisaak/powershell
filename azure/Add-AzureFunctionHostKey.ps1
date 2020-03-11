<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.NOTES
    General notes
#>

param (
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]
    $FunctionAppName,

    [Parameter(Mandatory = $true)]
    [hashtable]
    $FunctionKeys
)

$functionBaseUrl = 'https://{0}.azurewebsites.net' -f $FunctionAppName

$publishingCredentials = Invoke-AzResourceAction  `
    -ResourceGroupName $ResourceGroupName `
    -ResourceType 'Microsoft.Web/sites/config' `
    -ResourceName ('{0}/publishingcredentials' -f $FunctionAppName) `
    -Action list `
    -ApiVersion 2019-08-01 `
    -Force

$base64Credentials = [Convert]::ToBase64String(
    [Text.Encoding]::ASCII.GetBytes(
        ('{0}:{1}' -f $publishingCredentials.Properties.PublishingUserName, $publishingCredentials.Properties.PublishingPassword)
    )
)

$jwtToken = Invoke-RestMethod `
    -Uri ('https://{0}.scm.azurewebsites.net/api/functions/admin/token' -f $FunctionAppName) `
    -Headers @{ Authorization = ('Basic {0}' -f $base64Credentials) }

$FunctionKeys.Keys | ForEach-Object {
    if ($FunctionKeys[$_]) {
        Invoke-RestMethod `
            -Uri ('{0}/admin/host/keys/{1}' -f $functionBaseUrl, $_) `
            -Headers @{Authorization = ("Bearer {0}" -f $jwtToken) } `
            -Method Put `
            -Body ( @{ 'name' = $_; 'value' = $FunctionKeys[$_] } | ConvertTo-Json) `
            -ContentType 'application/json'
    }
    else {
        Invoke-RestMethod `
            -Uri ('{0}/admin/host/keys/{1}' -f $functionBaseUrl, $_) `
            -Headers @{Authorization = ("Bearer {0}" -f $jwtToken) } `
            -Method Post
    }
}