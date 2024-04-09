function getValue() {

    let samAccountName = Person.Accounts.MicrosoftActiveDirectory.sAMAccountName
    if (typeof samAccountName !== 'undefined' && samAccountName){
        return samAccountName;
    } else {
        return null;
    }   
}

getValue();