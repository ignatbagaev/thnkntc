# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId');
    $('div#answer-' + answer_id).hide();
    $('div#edit-answer-' + answer_id).show();

  $('.vote_answer').click () ->
    answer_id = $(this).data('answerId');

    vote = (selector) ->
      $(selector).bind 'ajax:success', (e, data, status, xhr) ->
        console.log("ok");
        $('p#rating-answer-' + answer_id).html("rating: " + data);
      .bind "ajax:error", (e, xhr, status, error) ->
        console.log("Error");

    vote('a#upvote-answer-' + answer_id);
    vote('a#downvote-answer-' + answer_id);
    vote('a#unvote-answer-' + answer_id);

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
