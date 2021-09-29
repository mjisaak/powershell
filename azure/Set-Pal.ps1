$partnerId = 'PAL'

az login --allow-no-subscriptions
az extension add --name managementpartner --only-show-errors
$initalTenant = az account show --query tenantId -o tsv

try {
    az account list --query [].tenantId -o tsv --only-show-errors  | 
    Select-Object -Unique |
    ForEach-Object {
        az login --tenant $_ --only-show-errors | out-null
        az managementpartner show 2>&1 | out-null
        if ($LASTEXITCODE -eq 1) {
            az managementpartner create --partner-id $partnerId --only-show-errors | out-null
        }
        else {
            az managementpartner update --partner-id $partnerId --only-show-errors | out-null
        }
    }
}
finally {
    az login --tenant $initalTenant
}
