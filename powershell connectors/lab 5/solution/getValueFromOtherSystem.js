function getSamAccountName() {
    let SamAccountName = '';

    // Voeg hier de logica toe om de bronwaarde correct te vertalen naar de HelloID waarde
    if (typeof Person.Accounts.MicrosoftActiveDirectory.sAMAccountName !== 'undefined' && Person.Accounts.MicrosoftActiveDirectory.sAMAccountName) {
        SamAccountName = Person.Accounts.MicrosoftActiveDirectory.sAMAccountName;
    }
    return SamAccountName;
}
getSamAccountName();