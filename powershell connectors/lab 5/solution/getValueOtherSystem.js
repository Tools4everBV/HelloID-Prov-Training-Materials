function getValue() {

    let samAccountName = Person.Accounts.MicrosoftActiveDirectory.SamAccountName
    if (typeof samAccountName !== 'undefined' && samAccountName){
        return samAccountName;
    } else {
        return null;
    }   
}

getValue();