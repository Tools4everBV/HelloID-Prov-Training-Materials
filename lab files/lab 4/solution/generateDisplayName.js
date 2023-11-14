// Please enter the mapping logic to generate the displayName based on name convention.
function generateDisplayName() {

    let firstName = Person.Name.NickName;
    let middleName = Person.Name.FamilyNamePrefix;
    let lastName = Person.Name.FamilyName;
    let middleNamePartner = Person.Name.FamilyNamePartnerPrefix;
    let lastNamePartner = Person.Name.FamilyNamePartner;
    let convention = Person.Name.Convention;


    switch (convention) {
        case "B":
            nameFormatted = firstName + ' ';
            if (typeof middleName !== 'undefined' && middleName) { nameFormatted = nameFormatted + ' ' + middleName }
            nameFormatted = nameFormatted + ' ' + lastName
            break;
        case "BP":
            nameFormatted = firstName + ' ';
            if (typeof middleName !== 'undefined' && middleName) { nameFormatted = nameFormatted + ' ' + middleName }
            nameFormatted = nameFormatted + ' ' + lastName
            if (typeof middleNamePartner !== 'undefined' && middleNamePartner) {
                nameFormatted = nameFormatted + ' - ' + middleNamePartner
                nameFormatted = nameFormatted + ' ' + lastNamePartner
            } else {
                nameFormatted = nameFormatted + ' - ' + lastNamePartner;
            }
            break;
        case "P":
            nameFormatted = firstName + ' ';
            if (typeof middleNamePartner !== 'undefined' && middleNamePartner) { nameFormatted = nameFormatted + ' ' + middleNamePartner }
            nameFormatted = nameFormatted + ' ' + lastNamePartner
            break;
        case "PB":
            nameFormatted = firstName + ' ';
            if (typeof middleNamePartner !== 'undefined' && middleNamePartner) { nameFormatted = nameFormatted + ' ' + middleNamePartner }
            nameFormatted = nameFormatted + ' ' + lastNamePartner
            if (typeof middleName !== 'undefined' && middleName) {
                nameFormatted = nameFormatted + ' - ' + middleName
                nameFormatted = nameFormatted + ' ' + lastName
            } else {
                nameFormatted = nameFormatted + ' - ' + lastName
            }
            break;
        default:
            nameFormatted = firstName + ' ';
            if (typeof middleName !== 'undefined' && middleName) { nameFormatted = nameFormatted + ' ' + middleName }
            nameFormatted = nameFormatted + ' ' + lastName
            break;
    }
    
    const displayName = nameFormatted.trim();

    return displayName;
}

generateDisplayName();

