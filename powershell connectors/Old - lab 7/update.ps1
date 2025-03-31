$path = $actionContext.Configuration.Path
$path = $path -replace '[\\/]?[\\/]$'
$file = $actionContext.Configuration.FileName
$exportPath = $path + "\" + $file
$delimiter = ";"

"<Write your logic here to get the data from the csv file and select the data from specific user>"

# Retrieve current account data for properties to be updated
$previousAccount = "<data from csv file from specific user>"

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
