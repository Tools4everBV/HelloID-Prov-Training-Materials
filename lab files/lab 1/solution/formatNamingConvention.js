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