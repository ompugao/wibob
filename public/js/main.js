String.prototype.htmlEscape = function(){
    var span = document.createElement('span');
    var txt =  document.createTextNode('');
    span.appendChild(txt);
    txt.data = this;
    return span.innerHTML;
};

$(function(){
    $.ajaxSetup({ "scriptCharset":'utf-8',
                  "error":function(XMLHttpRequest,textStatus, errorThrown) {   
                          console.log(textStatus);
                          console.log(errorThrown);
                          console.log(XMLHttpRequest.responseText);
                  }
    });
    $('button#sendURL').click(load_url);
    $('button#preview').click(load_text);
});

var load_url = function (){
    $.post(posturl_api,{ "url": $('input#url').val()},preview_mkd);
}

var load_text = function(){
    $.post(posttext_api,{"text": $('textarea#textmd').val()},preview_mkd);
}

var preview_mkd = function(json){
    console.log(json);
    $('textarea#textmd').val(json.markdown);
    $('div#preview_text').html(json.html);
}
