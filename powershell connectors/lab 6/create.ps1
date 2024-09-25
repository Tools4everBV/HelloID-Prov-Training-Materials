#Initialize default properties
$path = $actionContext.Configuration.Path
$path = $path -replace '[\\/]?[\\/]$'
$file = $actionContext.Configuration.FileName
$exportPath = $path + "\" + $file
$delimiter = ";"

# Check if we should try to correlate the account
if ($actionContext.CorrelationConfiguration.Enabled) {
    $correlationField = $actionContext.CorrelationConfiguration.accountField
    $correlationValue = $actionContext.CorrelationConfiguration.accountFieldValue

    if ($correlationField -eq $null){
        Write-Warning "Correlation is enabled but not configured correctly."
    }

    #  Write logic here that checks if the account can be correlated in the target system

    if ($correlatedAccount -ne $null) {
        $outputContext.AccountReference = $correlatedAccount.ExternalId
        $outputContext.Data.ExternalId = $correlatedAccount.ExternalId

        $outputContext.AuditLogs.Add([PSCustomObject]@{
            Action = "CorrelateAccount" # Optionally specify a different action for this audit log
            Message = "Correlated account with username $($correlatedAccount.UserName) on field $($correlationField) with value $($correlationValue)"
            IsError = $false
        })

        $outputContext.Success = $True
        $outputContext.AccountCorrelated = $True
    }
}

if (!$outputContext.AccountCorrelated) {
    # Create account object from mapped data and set the correct account reference
    $account = $actionContext.Data
    $outputContext.AccountReference = $account.ExternalId

    $incompleteAccount = $false

    if ($account.firstName -eq $null){
        $incompleteAccount = $true
        Write-Warning "Person does not have a firstname"
    }

    if ($incompleteAccount) {
        $outputContext.Success = $false

        $outputContext.AuditLogs.Add([PSCustomObject]@{
            Action = "CreateAccount" # Optionally specify a different action for this audit log
            Message = "Creating account failed: Person does not have a firstname"
            IsError = $True
        })
    }
    else
    {
        Try{
        if (-Not($actionContext.DryRun -eq $true)) {
            $account | Export-Csv $exportPath -Delimiter $Delimiter -NoTypeInformation -Append
            
            $outputContext.Success = $true
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                Action = "CreateAccount" # Optionally specify a different action for this audit log
                Message = "Export succesfully with username $($account.UserName)"
                IsError = $false
        })}     
        } 
        Catch{
            $outputContext.Success = $false
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                Action = "CreateAccount" # Optionally specify a different action for this audit log
                Message = "Export failed for user with username $($account.UserName)"
                IsError = $True
        })
    }}

    $outputContext.Data = $account
}
