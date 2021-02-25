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
$firstName = $p.Name.nickName;
$middleName = $p.Name.familyNamePrefix
$lastName = $p.Name.familyName;
$middleNamePartner = $p.Name.familyNamePartnerPrefix
$lastNamePartner = $p.Name.familyNamePartner
$nameConvention = $p.Name.Convention

$nameFormatted = $firstName

switch ($nameConvention) {
    "B" {
        if (($null -eq $middleName) -Or ($middleName -eq "")){
            $nameFormatted = $nameFormatted + " " + $lastName
        } else{
            $nameFormatted = $nameFormatted + " " + $middleName + " " + $lastName
        }   
    }
    "BP" {
        if (($null -eq $middleName) -Or ($middleName -eq "")){
            $nameFormatted = $nameFormatted + " " + $lastName
        } else{
            $nameFormatted = $nameFormatted + " " + $middleName + " " + $lastName
        }
        if (($null -eq $middleNamePartner) -Or ($middleNamePartner -eq "")){
            $nameFormatted = $nameFormatted + " - " + $lastNamePartner
        } else{
            $nameFormatted = $nameFormatted + " - " + $middleNamePartner + " " + $lastNamePartner
        }    
    }
    "P" {
        if (($null -eq $middleNamePartner) -Or ($middleNamePartner -eq "")){
            $nameFormatted = $nameFormatted + " " + $lastNamePartner
        } else{
            $nameFormatted = $nameFormatted + " " + $middleNamePartner + " " + $lastNamePartner
        }    
    }
    "PB" {
        if (($null -eq $middleNamePartner) -Or ($middleNamePartner -eq "")){
            $nameFormatted = $nameFormatted + " " + $lastNamePartner
        } else{
            $nameFormatted = $nameFormatted + " " + $middleNamePartner + " " + $lastNamePartner
        }
        if (($null -eq $middleName) -Or ($middleName -eq "")){
            $nameFormatted = $nameFormatted + " - " + $lastName
        } else{
            $nameFormatted = $nameFormatted + " - " + $middleName + " " + $lastName
        }    
    }
    Default{
        if (($null -eq $middleName) -Or ($middleName -eq "")){
            $nameFormatted = $nameFormatted + " " + $lastName
        } else{
            $nameFormatted = $nameFormatted + " " + $middleName + " " + $lastName
        } 
    }
}

#Change mapping here
$account = [PSCustomObject]@{
    displayName = $nameFormatted;
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