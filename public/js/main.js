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
    $('button#save').click(save_mkd);
});

var load_url = function (){
    var url = $('input#url').val();
    $.post(posturl_api,{ "url": url },preview_mkd);
    $('hidden#saved_url').val(url);
}

var load_text = function(){
    $.post(posttext_api,{"text": $('textarea#textmd').val()},preview_mkd);
}

var preview_mkd = function(json){
    console.log(json);
    if (json.markdown == "") {json.markdown="Could not encode the text correctly... Sorry."};

    $('textarea#textmd').val(json.markdown);
    $('div#preview_text').html(json.html);
}

var save_mkd = function (){
    $.post(save_api,
            {"commitpath": $('input#commitpath').val(),
             "commitlog":  $('input#commitlog').val(),
             "url":  $('hidden#saved_url').val() || $('input#url').val(),
             "text": $('textarea#textmd').val()},
            saved_callback);
}

var saved_callback = function(json){
    
}
