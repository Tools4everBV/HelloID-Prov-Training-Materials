// Example function based on a switch statement.
function formatNamingConvention()
{
    switch(source.Naamgebruik_code)
    {
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
formatNamingConvention()


// Alternative example function based on a if else construction.
function formatNamingConvention()
{
    let nameConv = source.Naamgebruik_code;
    if (source.Naamgebruik_code === "0"){
        nameConv = "B";
    }
    else if(source.Naamgebruik_code === "1"){
        nameConv = "PB";
    }
    else if(source.Naamgebruik_code === "2"){
        nameConv = "P";
    }
    else if(source.Naamgebruik_code === "3"){
        nameConv = "BP";
    }
    else{
        nameConv = "B";
    }
    return nameConv
}
formatNamingConvention();