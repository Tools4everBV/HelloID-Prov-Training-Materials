##################################################
# HelloID-Conn-Prov-Target-Training-Delete
# PowerShell V2
##################################################

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
        } elseif ($ErrorObject.Exception.GetType().FullName -eq 'System.Net.WebException') {
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
        } catch {
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

function Remove-CsvUser {
    param (
        [string]
        $Path,

        [string]
        $Delimiter,

        [string]
        $Id
    )
    $csv = Import-Csv -Path $Path -Delimiter $Delimiter

    $data = $csv | Where-Object { $_.Id -ne $Id } | Sort-Object Id
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
        Path        = $actionContext.Configuration.csvPath
        Delimiter   = $actionContext.Configuration.csvDelimiter
        Id          = $actionContext.References.Account
    }
    $correlatedAccount = Get-CsvUser @splatGetCsvUserParams

    # Another way to call the function:
    # $correlatedAccount = Get-CsvUser -Path $actionContext.Configuration.csvPath -Delimiter $actionContext.Configuration.csvDelimiter -Id = $actionContext.References.Account

    # End < Write Get logic here >

    if ($null -ne $correlatedAccount) {
        $action = 'DeleteAccount'
    } else {
        $action = 'NotFound'
    }

    # Process
    switch ($action) {
        'DeleteAccount' {
            if (-not($actionContext.DryRun -eq $true)) {
                Write-Information "Deleting Training account with accountReference: [$($actionContext.References.Account)]"

                # Start < Write Delete logic here >
                $splatRemoveCsvUserParams = @{
                    Path        = $actionContext.Configuration.csvPath
                    Delimiter   = $actionContext.Configuration.csvDelimiter
                    Id          = $actionContext.References.Account
                }
                $null = Remove-CsvUser @splatRemoveCsvUserParams

                # Another way to call the function:
                #$null = Remove-CsvUser -Path $actionContext.Configuration.csvPath -Delimiter $actionContext.Configuration.csvDelimiter -Id $actionContext.References.Account

                # End < Write Delete logic here >

            } else {
                Write-Information "[DryRun] Delete Training account with accountReference: [$($actionContext.References.Account)], will be executed during enforcement"
            }

            $outputContext.Success = $true
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                    Message = 'Delete account was successful'
                    IsError = $false
                })
            break
        }

        'NotFound' {
            Write-Information "Training account: [$($actionContext.References.Account)] could not be found, possibly indicating that it could be deleted"
            $outputContext.Success = $true
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                    Message = "Training account: [$($actionContext.References.Account)] could not be found, possibly indicating that it could be deleted"
                    IsError = $false
                })
            break
        }
    }
} catch {
    $outputContext.success = $false
    $ex = $PSItem
    if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException') -or
        $($ex.Exception.GetType().FullName -eq 'System.Net.WebException')) {
        $errorObj = Resolve-TrainingError -ErrorObject $ex
        $auditMessage = "Could not delete Training account. Error: $($errorObj.FriendlyMessage)"
        Write-Warning "Error at Line '$($errorObj.ScriptLineNumber)': $($errorObj.Line). Error: $($errorObj.ErrorDetails)"
    } else {
        $auditMessage = "Could not delete Training account. Error: $($_.Exception.Message)"
        Write-Warning "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    }
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Message = $auditMessage
            IsError = $true
        })
}