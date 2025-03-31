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
        $correlationValue
    )
    
    $data = Import-Csv -Path $Path -Delimiter $delimiter
    $user = $data | Where-Object { $_.$correlationField -eq $correlationValue }
    Write-Output $user
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
    $csv = Import-Csv -Path $Path -Delimiter $Delimiter

    # Extra check as the function might be used as not intended
    if ($csv | Where-Object { $_.Id -eq $User.Id }) {
        Throw "User with Id $($User.Id) already exists in the CSV file, please check your correlation configuration"
    }

    $data = [array]$csv + $User
    $data | Export-Csv -Path $Path -Delimiter $Delimiter -NoTypeInformation
    
    return $User
}

function Set-CsvUser {
    param (
        [string]
        $Path,

        [string]
        $Delimiter,

        [PSCustomObject]
        $User
    )
    $csv = Import-Csv -Path $Path -Delimiter $Delimiter

    # Check if user exists, the wrong function might be used
    if ($csv | Where-Object { $_.Id -ne $User.Id }) {
        Throw "Can't update user with Id $($User.Id) as it doesn't exists in the CSV file"
    }
    $data = $csv | Where-Object { $_.Id -ne $user.Id }
    $data = [array]$data + $user
    $data | Export-Csv -Path $Path -Delimiter $Delimiter -NoTypeInformation
}

function Remove-CsvUser {
    param (
        [string]
        $Path,

        [string]
        $Delimiter,

        [PSCustomObject]
        $User
    )
    $csv = Import-Csv -Path $Path -Delimiter $Delimiter

    # Check if user exists, the wrong function might be used
    if ($csv | Where-Object { $_.Id -ne $User.Id }) {
        Throw "User $($User.Id) cannot be found"
    }
    else {
        $data = $csv | Where-Object { $_.Id -ne $user.Id }
        Export-Csv -Path $Path -Delimiter $Delimiter -NoTypeInformation $data
    }
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

        # Retrieve user details using an (API) call and store the result in $correlatedAccount
        
        # Start van antwoord van Lab 7.1 correlatie in create script maken:
        $splatGetCsvUserParams = @{
            Path             = $actionContext.Configuration.csvPath
            Delimiter        = $actionContext.Configuration.csvDelimiter
            CorrelationField = $correlationField
            CorrelationValue = $correlationValue
        }
        $correlatedAccount = Get-CsvUser @splatGetCsvUserParams
        # Eind van antwoord van Lab 7.1 correlatie in create script maken:
    }

    if ($null -ne $correlatedAccount) {
        $action = 'CorrelateAccount'
    } else {
        $action = 'CreateAccount'
    }

    # Process
    switch ($action) {
        'CreateAccount' {
            $splatCreateParams = @{
                Uri    = $actionContext.Configuration.BaseUrl
                Method = 'POST'
                Body   = $actionContext.Data | ConvertTo-Json
            }

            # Make sure to test with special characters and if needed; add utf8 encoding.
            if (-not($actionContext.DryRun -eq $true)) {

                Write-Information 'Creating and correlating Training account'
                # Start van antwoord van Lab 8.1 account aanmaken in create script maken:
                $splatNewCsvUserParams = @{
                    Path        = $actionContext.Configuration.csvPath
                    Delimiter   = $actionContext.Configuration.csvDelimiter
                    User        = $actionContext.Data
                }
                $createdAccount = New-CsvUser @splatNewCsvUserParams
                # Eind van antwoord van Lab 8.1 account aanmaken in create script maken:

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