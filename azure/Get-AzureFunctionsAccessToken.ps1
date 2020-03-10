param (
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]
    $FunctionAppName
)

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

Invoke-RestMethod `
    -Uri ('https://{0}.scm.azurewebsites.net/api/functions/admin/token' -f $FunctionAppName) `
    -Headers @{ Authorization = ('Basic {0}' -f $base64Credentials) }

