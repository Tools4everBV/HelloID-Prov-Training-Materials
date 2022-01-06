#Initialize default properties
$c = $configuration | ConvertFrom-Json;
$path = "<Use connector configuration from UI component>"
$path = $path -replace '[\\/]?[\\/]$'
$file = "<Use connector configuration from UI component>"
$exportPath = $path + "\" + $file
$delimiter = ";"

$p = $person | ConvertFrom-Json;
$m = $manager | ConvertFrom-Json;

$success = $False;
$auditLogs = New-Object Collections.Generic.List[PSCustomObject];

$account_guid = $p.externalId

#Change mapping here
$account = [PSCustomObject]@{
    displayName = $p.DisplayName;
    firstName   = $p.Name.NickName;
    lastName    = $p.Name.FamilyName;
    userName    = $p.UserName;
    externalId  = $account_guid;
    title       = $p.PrimaryContract.Title.Name;
    department  = $p.PrimaryContract.Department.DisplayName;
    startDate   = $p.PrimaryContract.StartDate;
    endDate     = $p.PrimaryContract.EndDate;
    manager     = $p.PrimaryManager.DisplayName;
}

Try {
    if (-Not($dryRun -eq $True)) {
        #please enter your data export logic here
    }
    $success = $True;
    $auditLogs.Add([PSCustomObject]@{
        # Action = "CreateAccount"; Optionally specify a different action for this audit log
        Message = "export succesfully";
        IsError = $False;
    });
}
Catch {
    $auditLogs.Add([PSCustomObject]@{
        # Action = "CreateAccount"; Optionally specify a different action for this audit log
        Message = "export failed";
        IsError = $True;
    });
}

#build up result
$result = [PSCustomObject]@{ 
    Success          = $success;
    AccountReference = $account_guid;
    AuditLogs        = $auditLogs;
    Account          = $account;
};

#send result back
Write-Output $result | ConvertTo-Json -Depth 10