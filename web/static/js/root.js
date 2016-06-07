$(function() {
  $('#contents').loadTemplate('static/js/templates/list.html', {});
  loadFuncs();
});

function loadFuncs() {
  $.getJSON('functions', null, function(json) {
    $.each(json.items, function(id, func) {
      $('#list').loadTemplate('static/js/templates/list_card.html', {
        title: func.title || '(No title)',
        text: func.path,
        code: func.code
      }, {append: true})
    });
  });
};

function showForm() {
  $('#contents').loadTemplate('static/js/templates/form.html', {});
};
