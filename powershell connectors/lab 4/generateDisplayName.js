// Please enter the mapping logic to generate the displayName based on name convention.
function generateDisplayName() {

    let firstName = Person.Name.NickName;
    let middleName = Person.Name.FamilyNamePrefix;
    let lastName = Person.Name.FamilyName;
    let middleNamePartner = Person.Name.FamilyNamePartnerPrefix;
    let lastNamePartner = Person.Name.FamilyNamePartner;
    let convention = Person.Name.Convention;

    let nameFormatted = '';
    switch (convention) {
        case "B":
            "<logic>"
            break;
        case "BP":
            "<logic>"
            break;
        case "P":
            "<logic>"
            break;
        case "PB":
            "<logic>"
            break;
        default:
            nameFormatted = firstName;
            if (typeof middleName !== 'undefined' && middleName) { nameFormatted = nameFormatted + ' ' + middleName }
            nameFormatted = nameFormatted + ' ' + lastName
            break;
    }

    const displayName = nameFormatted.trim();

    return displayName;
}

generateDisplayName();

