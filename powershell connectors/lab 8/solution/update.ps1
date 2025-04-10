#################################################
# HelloID-Conn-Prov-Target-Training-Update
# PowerShell V2
#################################################

# Enable TLS1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

#region functions
function Resolve-TrainingError {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object]
        $ErrorObject
    )
    process {
        $httpErrorObj = [PSCustomObject]@{
            ScriptLineNumber = $ErrorObject.InvocationInfo.ScriptLineNumber
            Line             = $ErrorObject.InvocationInfo.Line
            ErrorDetails     = $ErrorObject.Exception.Message
            FriendlyMessage  = $ErrorObject.Exception.Message
        }
        if (-not [string]::IsNullOrEmpty($ErrorObject.ErrorDetails.Message)) {
            $httpErrorObj.ErrorDetails = $ErrorObject.ErrorDetails.Message
        }
        elseif ($ErrorObject.Exception.GetType().FullName -eq 'System.Net.WebException') {
            if ($null -ne $ErrorObject.Exception.Response) {
                $streamReaderResponse = [System.IO.StreamReader]::new($ErrorObject.Exception.Response.GetResponseStream()).ReadToEnd()
                if (-not [string]::IsNullOrEmpty($streamReaderResponse)) {
                    $httpErrorObj.ErrorDetails = $streamReaderResponse
                }
            }
        }
        try {
            $errorDetailsObject = ($httpErrorObj.ErrorDetails | ConvertFrom-Json)
            # Make sure to inspect the error result object and add only the error message as a FriendlyMessage.
            # $httpErrorObj.FriendlyMessage = $errorDetailsObject.message
            $httpErrorObj.FriendlyMessage = $httpErrorObj.ErrorDetails # Temporarily assignment
        }
        catch {
            $httpErrorObj.FriendlyMessage = $httpErrorObj.ErrorDetails
        }
        Write-Output $httpErrorObj
    }
}
#endregion

#region training functions
function Get-CsvUser {
    param (
        [string]
        $Path,

        [string]
        $Delimiter,

        [string]
        $Id
    )

    $data = Import-Csv -Path $Path -Delimiter $delimiter
    $user = $data | Where-Object { $_.Id -eq $Id }
    Write-Output $user
}

function Set-CsvUser {
    param (
        [string]
        $Path,

        [string]
        $Delimiter,

        [PSCustomObject]
        $User,

        [string]
        $Id
    )
    $csv = Import-Csv -Path $Path -Delimiter $Delimiter

    # Check if user exists
    if (($Id -Notin $csv.Id) ) {
        Throw "Can't update user with Id [$Id] as it doesn't exists in the CSV file"
    }

    # Map fields in $User over fields in the csv so no fields are skipped
    # Get all properties in user and csv

    $propertyNamesUser = $User.PsObject.Properties.Name # Merge into foreach loop?
    $UserCsv = $csv | Where-Object { $_.Id -eq $Id }
    $propertyNamesCsv = $UserCsv.PsObject.Properties.Name # Merge into foreach loop?

    foreach ($propertyNameCsv in $propertyNamesCsv) {
        if ($propertyNameCsv -NotIn $propertyNamesUser) {
            Write-Information "Adding property [$propertyNameCsv] to User [$Id] as it doesn't exist in the current field mapping"
            $User | Add-Member -MemberType NoteProperty -Name $propertyNameCsv -Value $UserCsv.$propertyNameCsv -Force
        }
    }

    $data = $csv | Where-Object { $_.Id -ne $Id }
    $data = [array]$data + $User | Sort-Object Id

    $data | Export-Csv -Path $Path -Delimiter $Delimiter -NoTypeInformation
}
#endregion

try {
    # Verify if [aRef] has a value
    if ([string]::IsNullOrEmpty($($actionContext.References.Account))) {
        throw 'The account reference could not be found'
    }

    Write-Information 'Verifying if a Training account exists'

    # Start < Write Get logic here >
    $splatGetCsvUserParams = @{
        Path      = $actionContext.Configuration.csvPath
        Delimiter = $actionContext.Configuration.csvDelimiter
        Id        = $actionContext.References.Account
    }
    $correlatedAccount = Get-CsvUser @splatGetCsvUserParams

    # Another way to call the function:
    # $correlatedAccount = Get-CsvUser -Path $actionContext.Configuration.csvPath -Delimiter $actionContext.Configuration.csvDelimiter -Id = $actionContext.References.Account

    # End < Write Get logic here >

    $outputContext.PreviousData = $correlatedAccount

    # Always compare the account against the current account in target system
    if ($null -ne $correlatedAccount) {
        $splatCompareProperties = @{
            ReferenceObject  = @($correlatedAccount.PSObject.Properties)
            DifferenceObject = @($actionContext.Data.PSObject.Properties)
        }
        $propertiesChanged = Compare-Object @splatCompareProperties -PassThru | Where-Object { $_.SideIndicator -eq '=>' }
        if ($propertiesChanged) {
            $action = 'UpdateAccount'
        }
        else {
            $action = 'NoChanges'
        }
    }
    else {
        $action = 'NotFound'
    }

    # Process
    switch ($action) {
        'UpdateAccount' {
            Write-Information "Account property(s) required to update: $($propertiesChanged.Name -join ', ')"

            # Make sure to test with special characters and if needed; add utf8 encoding.
            if (-not($actionContext.DryRun -eq $true)) {
                Write-Information "Updating Training account with accountReference: [$($actionContext.References.Account)]"

                # Start < Write Update logic here >
                $splatSetCsvUserParams = @{
                    Path      = $actionContext.Configuration.csvPath
                    Delimiter = $actionContext.Configuration.csvDelimiter
                    User      = $actionContext.Data
                    Id        = $actionContext.References.Account
                }
                $null = Set-CsvUser @splatSetCsvUserParams

                # Another way to call the function:
                # $null = Set-CsvUser -Path $actionContext.Configuration.csvPath -Delimiter $actionContext.Configuration.csvDelimiter -User $actionContext.Data -Id $actionContext.References.Account

                # End < Write Update logic here >

            }
            else {
                Write-Information "[DryRun] Update Training account with accountReference: [$($actionContext.References.Account)], will be executed during enforcement"
            }

            $outputContext.Success = $true
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                    Message = "Update account was successful, Account property(s) updated: [$($propertiesChanged.name -join ',')]"
                    IsError = $false
                })
            break
        }

        'NoChanges' {
            Write-Information "No changes to Training account with accountReference: [$($actionContext.References.Account)]"

            $outputContext.Success = $true
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                    Message = 'No changes will be made to the account during enforcement'
                    IsError = $false
                })
            break
        }

        'NotFound' {
            Write-Information "Training account: [$($actionContext.References.Account)] could not be found, possibly indicating that it could be deleted"
            $outputContext.Success = $false
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                    Message = "Training account with accountReference: [$($actionContext.References.Account)] could not be found, possibly indicating that it could be deleted"
                    IsError = $true
                })
            break
        }
    }
}
catch {
    $outputContext.Success = $false
    $ex = $PSItem
    if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException') -or
        $($ex.Exception.GetType().FullName -eq 'System.Net.WebException')) {
        $errorObj = Resolve-TrainingError -ErrorObject $ex
        $auditMessage = "Could not update Training account. Error: $($errorObj.FriendlyMessage)"
        Write-Warning "Error at Line '$($errorObj.ScriptLineNumber)': $($errorObj.Line). Error: $($errorObj.ErrorDetails)"
    }
    else {
        $auditMessage = "Could not update Training account. Error: $($ex.Exception.Message)"
        Write-Warning "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    }
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Message = $auditMessage
            IsError = $true
        })
}