# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $('div.question').hide();
    $('.edit-question').show()

  $('.vote_question').bind 'ajax:success', (e, data, status, xhr) ->
    $('p.question-rating').html("rating: " + data);
  .bind "ajax:error", (e, xhr, status, error) ->
    console.log("Error");

  PrivatePub.subscribe "/questions", (data, channel) ->
    $('div.list-group').prepend('<a id=' + data.question.id + ' class="list-group-item" href="questions/'+ data.question.id + '">' + data.question.title + '</a>')

  PrivatePub.subscribe "/questions_destroying", (data, channel) ->
    $('tr#'+ data.question.id).remove()

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);


