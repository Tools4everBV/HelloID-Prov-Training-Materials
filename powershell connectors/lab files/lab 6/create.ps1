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
        $account | Export-Csv $exportPath -Delimiter $delimiter -NoTypeInformation -Append
    }
    $success = $True;
    $auditLogs.Add([PSCustomObject]@{
            # Action = "CreateAccount"; Optionally specify a different action for this audit log
            Message = "export succesfull";
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