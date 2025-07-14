//The following example uses the substring() method
function formatInitials() {
    let initials;
    if ((!Person.Name.NickName === "") || (Person.Name.NickName != null)) {
        initials = Person.Name.NickName.substring(0,1);
    }
    return initials;
}
formatInitials();

//The following example uses the charAt() method
function formatInitials() {
    let initials;
    if ((!Person.Name.NickName === "") || (Person.Name.NickName != null)) {
        initials = Person.Name.NickName.charAt(0);
    }
    return initials;
}
formatInitials();