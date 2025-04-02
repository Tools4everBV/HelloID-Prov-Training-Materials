#####################################################
# HelloID-Conn-Prov-Source-Training-Persons
#####################################################

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
        Throw $_.Exception
    }
}
try {
    $persons = New-Object System.Collections.ArrayList
    Get-SourceConnectorData -SourceFile "T4E_HelloID_Persons.csv" ([ref]$persons)

    $employments = New-Object System.Collections.ArrayList
    Get-SourceConnectorData -SourceFile "T4E_HelloID_Contracts.csv" ([ref]$employments)

    $organizationalUnits = New-Object System.Collections.ArrayList
    Get-SourceConnectorData -SourceFile "T4E_HelloID_OrganizationalUnits.csv" ([ref]$organizationalUnits)

    $organizationalFunctions = New-Object System.Collections.ArrayList
    Get-SourceConnectorData -SourceFile "T4E_HelloID_OrganizationalFunctions.csv" ([ref]$organizationalFunctions)

    $organizationalUnits = $organizationalUnits | Group-Object ExternalId -AsHashTable
    $organizationalFunctions = $organizationalFunctions | Group-Object Functie -AsHashTable

    $employments | Add-Member -MemberType NoteProperty -Name "OrgUnitDesc" -Value $null -Force
    $employments | Add-Member -MemberType NoteProperty -Name "FunctionDesc" -Value $null -Force
    $employments | ForEach-Object {
        $organizationalUnit = $organizationalUnits[$_.OrganisatorischeEenheid] | Select-Object -First 1
        if ($organizationalUnit -ne $null) {
            $_.OrgUnitDesc = $organizationalUnit.Name
        }
        $organizationalFunction = $organizationalFunctions[$_.Functie] | Select-Object -First 1
        if ($organizationalFunction -ne $null) {
            $_.FunctionDesc = $organizationalFunction.Omschrijving
        }
    }

    # Group the employments
    $employments = $employments | Group-Object EmployeeNumber -AsHashTable

    # Extend the persons with positions and required fields
    $persons | Add-Member -MemberType NoteProperty -Name "Contracts" -Value $null -Force
    $persons | Add-Member -MemberType NoteProperty -Name "ExternalId" -Value $null -Force
    $persons | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $null -Force

    $persons | ForEach-Object {
        $_.ExternalId = $_.EmployeeNumber
        $_.DisplayName = "$($_.NickName) $($_.LastName) ($($_.ExternalId))" 
        $contracts = $employments[$_.EmployeeNumber]
        if ($null -ne $contracts) {
            $_.Contracts = $contracts
        }
        $person = $_ | ConvertTo-Json -Depth 10

        # Export and return the json
        Write-Output $person
    }
} catch {
    # error handler
    $ex = $PSItem
    Write-Warning "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
}