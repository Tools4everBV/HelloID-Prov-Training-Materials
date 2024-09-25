$importSourcePath = "C:\Tools4ever\HelloID\Training\Connector\SourceData\"
$delimiter = ";"
function Get-SourceConnectorData { 
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]$SourceFile,
        [parameter(Mandatory = $true)][ref]$data
    )

    try {
        $importSourcePath = $importSourcePath -replace '[\\/]?[\\/]$'
        $dataset = Import-Csv -Path "$importSourcePath\$SourceFile" -Delimiter $delimiter

        foreach ($record in $dataset) { 
            $null = $data.Value.add($record) 
        }
    }
    catch {
        $data.Value = $null
        Write-Verbose $_.Exception
    }
}

$organizationalUnits = New-Object System.Collections.ArrayList
Get-SourceConnectorData -SourceFile "T4E_HelloID_OrganizationalUnits.csv" ([ref]$organizationalUnits)

$json = $organizationalUnits | ConvertTo-Json -Depth 3
Write-Output $json