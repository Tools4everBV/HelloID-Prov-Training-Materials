$path = $actionContext.Configuration.Path
$path = $path -replace '[\\/]?[\\/]$'
$file = $actionContext.Configuration.FileName
$exportPath = $path + "\" + $file
$delimiter = ";"

# Check if we should try to correlate the account
if ($actionContext.CorrelationConfiguration.Enabled) {
    $correlationField = $actionContext.CorrelationConfiguration.accountField
    $correlationValue = $actionContext.CorrelationConfiguration.accountFieldValue

    if ($correlationField -eq $null) {
        Write-Warning "Correlation is enabled but not configured correctly."
    }

    #Before exporting the $account you need to check in here if the user is not already present in the collection
    $fileExists = Test-Path $exportPath

    if ($fileExists -eq $True) { $cache = Import-Csv $exportPath -Delimiter $delimiter } Else { $cache = $null }

    #Check if account reference is already in the CSV file
    if ((![string]::IsNullOrEmpty($cache)) -and ($cache | where { $_.$correlationField -eq $correlationValue })) {
        $correlatedAccount = $cache | where { $_.$correlationField -eq $correlationValue }
    }
}

# Retrieve current account data for properties to be updated
$previousAccount = $correlatedAccount

# Create object to build desired account
$account = @{}

# Update mapped person properties
foreach ($property in $actionContext.Data.PsObject.Properties) {
    $account[$property.Name] = $property.Value;
}

# Update changed person properties
if (($personContext.PersonDifferences.DisplayName) -and ($personContext.PersonDifferences.DisplayName.Change -eq "Updated")) {
    $account.DisplayName = $personContext.PersonDifferences.DisplayName.New
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Action  = "UpdateAccount" # Optionally specify a different action for this audit log
            Message = "Updated display name for account with username $($personContext.Person.DisplayName)"
            IsError = $false
        })
}

if ($actionContext.AccountCorrelated) {
    # Execute initial update after account correlation
}

if (-Not($actionContext.DryRun -eq $true)) {
    # Write update logic here
}

$outputContext.Success = $true

$outputContext.AuditLogs.Add([PSCustomObject]@{
        Action  = "UpdateAccount" # Optionally specify a different action for this audit log
        Message = "Account with username $($account.displayName) updated"
        IsError = $false
    })

$outputContext.Data = $account
write-verbose $outputContext.Data.displayname -verbose
$outputContext.PreviousData = $previousAccount
