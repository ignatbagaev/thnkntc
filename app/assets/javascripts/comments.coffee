$ ->
  $('a.new_comment_link').click (e) -> 
    e.preventDefault();
    type = $(this).data('commentableType');
    id = $(this).data('commentableId');
    console.log(type, id)
    $('a.new_comment_link').show();
    $('div.new_comment_form').hide();
    $(this).hide();
    $('div#new_comment_for_' + type + id).show();

  $(this).bind 'ajax:success', ->
    $('a.new_comment_link').show();
    $('div.new_comment_form').hide();
