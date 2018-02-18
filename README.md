# PowerShell
This repository contains some PowerShell scripts / snippets

## Convenience method to copy a whole directory using Robocopy:
```powershell
function Copy-Directory
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Source,

        [Parameter(Mandatory=$true, Position=1)]
        [string]$Destination,

        [Parameter(Mandatory=$false, Position=2)]
        [string[]]$Exclude
    )
    

    if (Test-Path $Destination)
    {
        New-Item $Destination -ItemType directory -Force | Out-Null
    }

	$param = @('/E', '/xf', $Exclude)        
    Robocopy $Source $Destination @param
}
```
## Test Database Connectivity
Uses the SqlConnection class to test a connection. 
```powershell
function Test-SQLConnection
{    
    [OutputType([bool])]
    Param
    (
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $ConnectionString
    )
    try
    {
        $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString;
        $sqlConnection.Open();
        $sqlConnection.Close();

        return $true;
    }
    catch
    {
        return $false;
    }
}
```

Usage example:
```powershell
Test-SQLConnection "Data Source=localhost;database=myDB;User ID=myUser;Password=myPassword;"
```
