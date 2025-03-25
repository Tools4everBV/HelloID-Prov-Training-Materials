// Example function based on a switch statement.
// Please copy this function without the comment lines
function formatNamingConvention() {
    let HrNamingConvention = source.Naamgebruik_code;
    let HelloIdNamingConvention = '';

    switch (HrNamingConvention) {
        case '1':
            HelloIdNamingConvention = 'PB';
            break;
        case '2':
            HelloIdNamingConvention = 'P';
            break;
        case '3':
            HelloIdNamingConvention = 'BP';
            break;
        case '0':
        default:
            HelloIdNamingConvention = 'B';
            break;
    }
    return HelloIdNamingConvention;
}
formatNamingConvention();


// Alternative example function based on a if else construction.
// Please copy this function without the comment lines
function formatNamingConvention() {
    let HrNamingConvention = source.Naamgebruik_code;
    let HelloIdNamingConvention = 'B';

    if (HrNamingConvention === '0') {
        HelloIdNamingConvention = 'B';
    }
    else if (HrNamingConvention === '1') {
        HelloIdNamingConvention = 'PB';
    }
    else if (HrNamingConvention === '2') {
        HelloIdNamingConvention = 'P';
    }
    else if (HrNamingConvention === '3') {
        HelloIdNamingConvention = 'BP';
    }
    else {
        HelloIdNamingConvention = 'B';
    }
    return HelloIdNamingConvention;
}
formatNamingConvention();