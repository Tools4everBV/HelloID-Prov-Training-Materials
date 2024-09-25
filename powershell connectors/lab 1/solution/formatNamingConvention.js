// Example function based on a switch statement.
// Please copy this function without the comment lines
function formatNamingConvention() {
    switch (source.Naamgebruik_code) {
        case "0":
            return "B";
            break;
        case "1":
            return "PB";
            break;
        case "2":
            return "P";
            break;
        case "3":
            return "BP";
            break;
        default:
            return "B";
            break;
    }
}
formatNamingConvention();


// Alternative example function based on a if else construction.
// Please copy this function without the comment lines
function formatNamingConvention() {
    let nameConv = "B";
    if (source.Naamgebruik_code === "0") {
        nameConv = "B";
    }
    else if (source.Naamgebruik_code === "1") {
        nameConv = "PB";
    }
    else if (source.Naamgebruik_code === "2") {
        nameConv = "P";
    }
    else if (source.Naamgebruik_code === "3") {
        nameConv = "BP";
    }
    else {
        nameConv = "B";
    }
    return nameConv;
}
formatNamingConvention();