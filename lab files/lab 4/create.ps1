
#Initialize default properties
$p = $person | ConvertFrom-Json;
$success = $False;
$auditMessage = "for person " + $p.DisplayName;

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

$path = "<Use connector configuration>"
$file = $path + "<Use connector configuration>"
$Delimiter = ";"

Try {
    if (-Not($dryRun -eq $True)) {
        $account | Export-Csv $file -Delimiter $Delimiter -NoTypeInformation -Append
    }
    $success = $True;
    $auditMessage = "export succesfully";
}

Catch {
    $auditMessage = "export failed"
}

#build up result
$result = [PSCustomObject]@{ 
    Success          = $success;
    AccountReference = $account_guid;
    AuditDetails     = $auditMessage;
    Account          = $account;
};

#send result back
Write-Output $result | ConvertTo-Json -Depth 10