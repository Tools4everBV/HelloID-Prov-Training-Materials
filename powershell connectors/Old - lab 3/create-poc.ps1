# create 4 functions
# Get-CsvUser
# New-CsvUser
# Set-CsvUser
# Remove-CsvUser


#let op, je werkt met CSV - wat betekent dat? -> concurrent sessions op 1!
# Field available in standard mapping
<#
    Department
    DisplayName
    EndDate
    ExternalId
    FamilyName
    Manager
    NickName
    StartDate
    Title
    UserName

    Remove fields
    - Manager
    Map Fields
    - zorg dat je het verschil maakt tussen create en update
    - zorg ervoor dat de displayname en de username bij op het account tabje van de persoonsinformatie getoond wordt
        Department
        DisplayName
        EndDate
        ExternalId
        FamilyName
        NickName
        StartDate
        Title
        UserName
    Change displayname according to configuration, use helperfunctions
    Rename externalId to Id
    Add fields and map them
        FamilyNamePrefix
        PartnetNamePrefix
        PartnerName
        NameConventionCode
#>

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

    $data = $csv + $User
    Export-Csv -Path $Path -Delimiter $Delimiter -NoTypeInformation $data
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
    $data += $user
    Export-Csv -Path $Path -Delimiter $Delimiter -NoTypeInformation $data
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

$splatGetCsvUserParams = @{
    Path             = "C:\Users\R.Jongbloed\OneDrive - Tools4ever B.V\Documenten\Tools4everGit\HelloID-Prov-Training-Materials\powershell connectors\lab 3\storage.csv"   
    #Path             = "C:\Users\ricad\OneDrive - Tools4ever B.V\Documenten\Tools4everGit\HelloID-Prov-Training-Materials\powershell connectors\lab 3\storage.csv"
    Delimiter        = ";"
    CorrelationField = "Id"
    CorrelationValue = "123456"
}
$user = Get-CsvUser @splatGetCsvUserParams
$user | Format-Table

$splatNewCsvUserParams = @{
    Path             = "C:\Users\R.Jongbloed\OneDrive - Tools4ever B.V\Documenten\Tools4everGit\HelloID-Prov-Training-Materials\powershell connectors\lab 3\storage.csv"   
    #Path             = "C:\Users\ricad\OneDrive - Tools4ever B.V\Documenten\Tools4everGit\HelloID-Prov-Training-Materials\powershell connectors\lab 3\storage.csv"
    Delimiter = ";"
    User      = $user  # of gebruik $actionContext.data?
}
$null = New-CsvUser @splatNewCsvUserParams

$splatSetCsvUserParams = @{
    Path             = "C:\Users\R.Jongbloed\OneDrive - Tools4ever B.V\Documenten\Tools4everGit\HelloID-Prov-Training-Materials\powershell connectors\lab 3\storage.csv"   
    #Path             = "C:\Users\ricad\OneDrive - Tools4ever B.V\Documenten\Tools4everGit\HelloID-Prov-Training-Materials\powershell connectors\lab 3\storage.csv"
    Delimiter = ";"
    User      = $user  # of gebruik $actionContext.data?
}
$null = Set-CsvUser @splatSetCsvUserParams

$splatSetCsvUserParams = @{
    Path             = "C:\Users\R.Jongbloed\OneDrive - Tools4ever B.V\Documenten\Tools4everGit\HelloID-Prov-Training-Materials\powershell connectors\lab 3\storage.csv"   
    #Path             = "C:\Users\ricad\OneDrive - Tools4ever B.V\Documenten\Tools4everGit\HelloID-Prov-Training-Materials\powershell connectors\lab 3\storage.csv"
    Delimiter = ";"
    User      = $user  # of gebruik $actionContext.data?
}
$null = Remove-CsvUser @splatSetCsvUserParams