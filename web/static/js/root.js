function loadFuncs() {
  $.getJSON('functions', null, function(json) {
    $.each(json.items, function(id, func) {
      $('#list').loadTemplate('static/js/templates/list_card.html', {
        title: func.title || '(No title)',
        text: func.path,
        code: func.code,
        link: '/' + func.path
      }, {append: true})
    });
  });
};

function showForm() {
  $('#contents').loadTemplate('static/js/templates/form.html', {
    host: location.href
  });
};

function showList() {
  $('#contents').loadTemplate('static/js/templates/list.html', {});
  loadFuncs();
};

function postFunc() {
  var title = $('#function_title').val()
  var path = $('#function_path').val()
  var code = $('#function_code').val()
  if(path.length > 0 && code.length > 0) {
    var data = {
      path: path,
      code: code
    }
    if(title.length > 0) {data.title = title}
    $.post('functions', data, function() {
      showList();
    }, 'json');
  } else {
    $('#error').text('`Path` and `Code` are required!');
  };
}

$(function() {
  showList();
});
