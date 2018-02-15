# PowerShell
This repository contains some PowerShell scripts / snippets

## Cnvenience method to copy a whole directory using Robocopy:
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
