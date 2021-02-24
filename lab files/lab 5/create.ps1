
#Initialize default properties
$p = $person | ConvertFrom-Json;
$success = $False;
$auditMessage = "for person " + $p.DisplayName;

$account_guid = New-Guid

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
    "P" {
        if (($null -eq $middleNamePartner) -Or ($middleNamePartner -eq "")){
            $nameFormatted = $nameFormatted + " " + $lastNamePartner
        } else{
            $nameFormatted = $nameFormatted + " " + $middleNamePartner + " " + $lastNamePartner
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
    Default {
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
    firstName= $p.Name.NickName;
    lastName= $p.Name.FamilyName;
    userName = $p.UserName;
    externalId = $account_guid;
    title = $p.PrimaryContract.Title.Name;
    department = $p.PrimaryContract.Department.DisplayName;
    startDate = $p.PrimaryContract.StartDate;
    endDate = $p.PrimaryContract.EndDate;
    manager = $p.PrimaryManager.DisplayName;
}

$path = "<Use connector configuration>"
$file = $path + "<Use connector configuration>"
$Delimiter = ";"

Try{
    if(-Not($dryRun -eq $True)) {
    $account | Export-Csv $file -Delimiter $Delimiter -NoTypeInformation -Append
}
    $success = $True;
    $auditMessage = "export succesfully";
}

Catch{
    $auditMessage = "export failes"
}

#build up result
$result = [PSCustomObject]@{ 
	Success= $success;
	AccountReference= $account_guid;
	AuditDetails=$auditMessage;
    Account = $account;
};

#send result back
Write-Output $result | ConvertTo-Json -Depth 10