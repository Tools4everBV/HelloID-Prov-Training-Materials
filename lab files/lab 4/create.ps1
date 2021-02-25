#Initialize default properties
$c = $configuration | ConvertFrom-Json;
$path = $($c.Path)
$path = $path -replace '[\\/]?[\\/]$'
$file = $($c.FileName)
$exportPath = $path + "\" + $file
$delimiter = ";"

$p = $person | ConvertFrom-Json;
$m = $manager | ConvertFrom-Json;

$success = $False;
$auditLogs = New-Object Collections.Generic.List[PSCustomObject];

$account_guid = $p.externalId

#Build you generation of the DisplayName
<logic>

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
        $account | Export-Csv $exportPath -Delimiter $Delimiter -NoTypeInformation -Append
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