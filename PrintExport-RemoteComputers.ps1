# PrintExport-RemoteComputers
# Requires WinRM to be functional and accessible remotely

param (
    [string]$Comp = "localhost"
)

function ListAllPrinters {
    param (
        [string]$Comp
    )

    Invoke-Command -ComputerName $Comp -ScriptBlock {
        Get-ChildItem Registry::\HKEY_Users | 
        Where-Object { $_.PSChildName -NotMatch ".DEFAULT|S-1-5-18|S-1-5-19|S-1-5-20|_Classes" } | 
        Select-Object -ExpandProperty PSChildName | 
        ForEach-Object { Get-ChildItem Registry::\HKEY_Users\$_\Printers\Connections -Recurse | Select-Object -ExpandProperty Name }
    }
}

# Main
# ListAllPrinters $Comp

Import-Module ActiveDirectory

get-adcomputer -Filter *

foreach ($computer in $computers) {
    ListAllPrinters $_.name
}