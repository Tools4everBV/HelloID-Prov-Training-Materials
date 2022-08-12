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
$nameformatted = $p.Name.NickName

switch ($p.Name.Convention) {
    "B" { $nameformatted = "$($nameformatted) $($p.Name.FamilyNamePrefix) $($p.Name.FamilyName)" }
    "P" { $nameformatted = "$($nameformatted) $($p.Name.FamilyNamePartnerPrefix) $($p.Name.FamilyNamePartner)" }
    "BP" { $nameformatted = "$($nameformatted) $($p.Name.FamilyNamePrefix) $($p.Name.FamilyName) - $($p.Name.FamilyNamePartnerPrefix) $($p.Name.FamilyNamePartner)" }
    "PB" { $nameformatted = "$($nameformatted) $($p.Name.FamilyNamePartnerPrefix) $($p.Name.FamilyNamePartner) - $($p.Name.FamilyNamePrefix) $($p.Name.FamilyName)" }
    Default { $nameformatted = "$($nameformatted) $($p.Name.FamilyNamePrefix) $($p.Name.FamilyName)" }
}
$nameformatted = $nameformatted -replace '\s+', ' '

#Retrieve the sAMAccountName property for the user, please make sure to use the correct system idenifier from your system
$sAMAccountName = $p.Accounts.MicrosoftActiveDirectory.sAMAccountName; #Extend your mapping to also include the sAMAccountName of a user from Active Directory

#Change mapping here
$account = [PSCustomObject]@{
    displayName      = $nameFormatted;
    firstName        = $p.Name.NickName;
    lastName         = $p.Name.FamilyName;
    userName         = $p.UserName;
    externalId       = $account_guid;
    title            = $p.PrimaryContract.Title.Name;
    department       = $p.PrimaryContract.Department.DisplayName;
    startDate        = $p.PrimaryContract.StartDate;
    endDate          = $p.PrimaryContract.EndDate;
    manager          = $p.PrimaryManager.DisplayName;
    ADsAMAccountName = $sAMAccountName; 
}

Try {
    if (-Not($dryRun -eq $True)) {
        #Before exporting the $account you need to check in here if the user is not already present in the collection
        $create = $True
        $fileExists = Test-Path $exportPath
        if ($fileExists -eq $True) { $cache = Import-Csv $exportPath -Delimiter $delimiter } Else { $cache = $null }
        
        #Check if account reference is already in the CSV file
        if((![string]::IsNullOrEmpty($cache)) -and ($cache | where {$_.externalId -eq $account_guid})) 
        {
            $create = $False
            $success = $True
            $auditLogs.Add([PSCustomObject]@{
                # Action = "CreateAccount"; Optionally specify a different action for this audit log
                Message = "Correlation record found $($account_guid).";
                IsError = $False;
            });
        }
        
        if($create)
        {
            $account | Export-Csv $exportPath -Delimiter $delimiter -NoTypeInformation -Append
            $success = $True;
            $auditLogs.Add([PSCustomObject]@{
                # Action = "CreateAccount"; Optionally specify a different action for this audit log
                Message = "export succesfull for record $($account_guid)";
                IsError = $False;
            });
        }
    }
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