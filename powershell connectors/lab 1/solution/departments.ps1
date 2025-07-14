#####################################################
# HelloID-Conn-Prov-Source-Training-Departments
#####################################################

$config = $configuration | ConvertFrom-Json
$importSourcePath = $config.path
$delimiter = $config.delimiter

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
        Throw $_.Exception
    }
}
try {
    $organizationalUnits = New-Object System.Collections.ArrayList
    Get-SourceConnectorData -SourceFile "T4E_HelloID_OrganizationalUnits.csv" ([ref]$organizationalUnits)

    foreach ($organizationalUnit in $organizationalUnits) {
        Write-Output $organizationalUnit | ConvertTo-Json -Depth 3
    }
} catch {
    # error handler
    $ex = $PSItem
    Write-Warning "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
}