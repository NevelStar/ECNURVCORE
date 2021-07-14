var total = 30;

var stackdata = {
    'aaData': [
    ],
    'aoColumns': [
        {'sTitle': 'Stack Name', 'bSearchable': false,'sWidth': '40%'},
        {'sTitle': 'Hiden Name', 'bSearchable': true, 'bVisible': false,'sWidth': '40%'},
        {'sTitle': 'Inclusive Time', 'bSearchable': false, 'sType': 'simprofile', 'sWidth': '30%'},
        {'sTitle': 'Exclusive Time', 'bSearchable': false, 'sType': 'simprofile', 'sWidth': '30%'}
    ],
    'sScrollX': '300px',
    'sScrollY': '460px',
    'bPaginate': false,
    'bScrollCollapse': true,
    'aoColumnDefs': [
       {'fnRender': function(oObj, sVal){
           var input = sVal * 1000000 * 0.29 / 30;
           var ret;
           if(input>1000000){
               ret = (input/1000000).toFixed(1).toString() + ' s';
           }else if(input>1000){
               ret = (input/1000).toFixed(1).toString() + ' ms';
           }else if(input==0){
               return '0';
           }else{
               ret = input.toFixed(1).toString() + ' us';
           }
               return ret + ' (' + (sVal/total*100).toFixed(1).toString()+'%)';
           }, 'aTargets': [ 2, 3 ]
       },
       { 'sClass': 'stackcentre', 'aTargets': [ 2, 3 ]}
    ]
}


jQuery.fn.dataTableExt.oSort['simprofile-asc'] = function(a,b) {
    var va, vb;
    var aa = a.split(' ');
    var ab = b.split(' ');
    if(aa.length<2){
        va = parseFloat(aa[0])
    }else if(aa[1] == "us"){
        va = parseFloat(aa[0])
    }else if(aa[1] == "ms"){
        va = parseFloat(aa[0])*1000
    }else if(aa[1] == "s"){
        va = parseFloat(aa[0])*1000000
    }
    if(ab.length<2){
        vb = parseFloat(ab[0])
    }else if(ab[1] == "us"){
        vb = parseFloat(ab[0])
    }else if(ab[1] == "ms"){
        vb = parseFloat(ab[0])*1000
    }else if(ab[1] == "s"){
        vb = parseFloat(ab[0])*1000000
    }
    return ((va < vb) ? -1 : ((va > vb) ? 1 : 0));
}
jQuery.fn.dataTableExt.oSort['simprofile-desc'] = function(a,b) {
    var va, vb;
    var aa = a.split(' ');
    var ab = b.split(' ');
    if(aa.length<2){
        va = parseFloat(aa[0])
    }else if(aa[1] == "us"){
        va = parseFloat(aa[0])
    }else if(aa[1] == "ms"){
        va = parseFloat(aa[0])*1000
    }else if(aa[1] == "s"){
        va = parseFloat(aa[0])*1000000
    }
    if(ab.length<2){
        vb = parseFloat(ab[0])
    }else if(ab[1] == "us"){
        vb = parseFloat(ab[0])
    }else if(ab[1] == "ms"){
        vb = parseFloat(ab[0])*1000
    }else if(ab[1] == "s"){
        vb = parseFloat(ab[0])*1000000
    }
    return ((va < vb) ?  1 : ((va > vb) ? -1 : 0));
}
function readData(fileName, begin, end) {
    try {        netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
        var file = Components.classes['@mozilla.org/file/local;1'].createInstance(Components.interfaces.nsILocalFile);
        file.initWithPath(fileName);
        var lineToRead = end - begin + 1;
        if(lineToRead > 500){
            lineToRead = 500;
        }
        var istream = Components.classes['@mozilla.org/network/file-input-stream;1'].createInstance(Components.interfaces.nsIFileInputStream);
        istream.init(file, 0x01, 00004, 0);
        istream.QueryInterface(Components.interfaces.nsILineInputStream);
        istream.QueryInterface(Components.interfaces.nsISeekableStream);
        var line = {};
        var source = '';
        var lineNo = 0;
        var hasMore = true;
        while(lineToRead > 0 && hasMore){
            hasMore = istream.readLine(line);
            lineNo ++;
            if(lineNo >= begin){
                lineToRead --;
                source = source + line.value + '\n';
            }
        }
    } catch (err) {
        return "";
    }
    return source;
}

function getNameOfLink(str,limit) {
    var spn = $('<span style="visibility:hidden"></span>').text(str).appendTo('body');
    if (parseInt(spn.width()) > parseInt(limit)*0.4) {
        return str.substr(0, 20) + "...";
    } else {
        return str;
    }
}

$(document).ready(function() {
    $('#stacktable').dataTable(stackdata);
    $('.dataTables_scrollHead').width('100%');
    $('.dataTables_scrollBody').width('100%');
    $('.dataTables_scrollHeadInner').width('100%');
    $('.dataTable').width('100%');
    $(window).resize(function() {
         $('.dataTable a').each(function() {
             $(this).text(getNameOfLink($(this).attr('title'), $('.dataTable').width()))
         });
    });
    $('.dataTable a').each(function() {
        $(this).text(getNameOfLink($(this).attr('title'), $('.dataTable').width()))
    });
    if(vlsrc != 'Source Unknown'){
        if(vlsrc.lastIndexOf('-') > vlsrc.lastIndexOf(':')){
            var fileName = vlsrc.substr(0, vlsrc.lastIndexOf(':'));
            var begin = parseInt(vlsrc.substr(vlsrc.lastIndexOf(':')+1, vlsrc.lastIndexOf('-')));
            var end = parseInt(vlsrc.substr(vlsrc.lastIndexOf('-')+1));
        }
    }
});
