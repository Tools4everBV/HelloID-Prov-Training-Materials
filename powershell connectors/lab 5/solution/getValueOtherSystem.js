function getValue() {

    let username = Person.Accounts.MicrosoftActiveDirectory.SamAccountName
    if (typeof username !== 'undefined' && username){
        return username;
    } else {
        return null;
    }   
}

getValue();