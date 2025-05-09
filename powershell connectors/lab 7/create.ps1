#################################################
# HelloID-Conn-Prov-Target-Training-Create
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

#region Training functions
function Get-CsvUser {
    param (
        [string]
        $Path,

        [string]
        $Delimiter,

        [string]
        $CorrelationField,

        [string]
        $CorrelationValue
    )

    if (Test-Path $Path) {
        $data = Import-Csv -Path $Path -Delimiter $delimiter
        $user = $data | Where-Object { $_.$CorrelationField -eq $CorrelationValue }
        Write-Output $user
    } else {
        $user = $null
    }
}

function New-CsvUser {
    param (
        [string]
        $Path,

        [string]
        $Delimiter,

        [PSCustomObject]
        $User
    )
    if (Test-Path $Path) {
        $csv = Import-Csv -Path $Path -Delimiter $Delimiter

        # Extra check as the function might be used as not intended
        if ($User.Id -In $csv.Id)  {
            Throw "User with Id $($User.Id) already exists in the CSV file, please check your correlation configuration"
        }
    }

    $data = [array]$csv + $User | Sort-Object Id
    $data | Export-Csv -Path $Path -Delimiter $Delimiter -NoTypeInformation

    return $User
}
#endregion

try {
    # Initial assignments
    $outputContext.AccountReference = 'Currently not available'

    # Validate correlation configuration
    if ($actionContext.CorrelationConfiguration.Enabled) {
        $correlationField = $actionContext.CorrelationConfiguration.AccountField
        $correlationValue = $actionContext.CorrelationConfiguration.PersonFieldValue

        if ([string]::IsNullOrEmpty($($correlationField))) {
            throw 'Correlation is enabled but not configured correctly'
        }
        if ([string]::IsNullOrEmpty($($correlationValue))) {
            throw 'Correlation is enabled but [accountFieldValue] is empty. Please make sure it is correctly mapped'
        }

        # Determine if a user needs to be [created] or [correlated]

        # Start < Write Get logic here >

        # End < Write Get logic here >
    } else {
        throw 'Correlation is not enabled'
    }

    if ($null -ne $correlatedAccount) {
        $action = 'CorrelateAccount'
    } else {
        $action = 'CreateAccount'
    }

    # Process
    switch ($action) {
        'CreateAccount' {

            # Make sure to test with special characters and if needed; add utf8 encoding.
            if (-not($actionContext.DryRun -eq $true)) {

                Write-Information 'Creating and correlating Training account'

                # Start < Write Create logic here >

                # End < Write Create logic here >

                $outputContext.Data = $createdAccount
                $outputContext.AccountReference = $createdAccount.Id
            } else {
                Write-Information '[DryRun] Create and correlate Training account, will be executed during enforcement'
            }
            $auditLogMessage = "Create account was successful. AccountReference is: [$($outputContext.AccountReference)]"
            break
        }

        'CorrelateAccount' {
            Write-Information 'Correlating Training account'

            $outputContext.Data = $correlatedAccount
            $outputContext.AccountReference = $correlatedAccount.Id
            $outputContext.AccountCorrelated = $true
            $auditLogMessage = "Correlated account: [$($outputContext.AccountReference)] on field: [$($correlationField)] with value: [$($correlationValue)]"
            break
        }
    }

    $outputContext.success = $true
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Action  = $action
            Message = $auditLogMessage
            IsError = $false
        })
} catch {
    $outputContext.success = $false
    $ex = $PSItem
    if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException') -or
        $($ex.Exception.GetType().FullName -eq 'System.Net.WebException')) {
        $errorObj = Resolve-TrainingError -ErrorObject $ex
        $auditMessage = "Could not create or correlate Training account. Error: $($errorObj.FriendlyMessage)"
        Write-Warning "Error at Line '$($errorObj.ScriptLineNumber)': $($errorObj.Line). Error: $($errorObj.ErrorDetails)"
    } else {
        $auditMessage = "Could not create or correlate Training account. Error: $($ex.Exception.Message)"
        Write-Warning "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    }
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Message = $auditMessage
            IsError = $true
        })
}