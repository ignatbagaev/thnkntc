module AnswersHelper
  def answer_edit_link(answer, content = "Edit")
    return unless can?(:update, answer)
    link_to('Edit answer', edit_answer_path(answer),
      class: "btn btn-default edit-answer-link edit-answer-link-#{answer.id}",
      data: {answer_id: answer.id}
    )
  end

  def answer_destroy_link(answer, content = "Delete question")
    return unless can?(:destroy, answer)
    link_to 'Delete answer', answer_path(answer), method: :delete, remote: true, class: 'btn btn-default'
  end

  def link_to_upvote_answer(answer, content = "Upvote")
    return unless can?(:upvote, answer)
    link_to("upvote", upvote_answer_path(answer),
      method: :post,
      remote: true,
      id: "upvote-answer-#{answer.id}",
      class: 'vote_answer btn btn-default pull-left',
      data: { type: :html, answer_id: answer.id }
    )
  end

  def link_to_downvote_answer(answer, content = "Downvote")
    return unless can?(:downvote, answer)
    link_to("downvote", downvote_answer_path(answer),
      method: :post,
      remote: true,
      id: "downvote-answer-#{answer.id}",
      class: 'vote_answer btn btn-default pull-left',
      data: { type: :html, answer_id: answer.id }
    )
  end

  def link_to_unvote_answer(answer, content = "Unvote")
    return unless can?(:unvote, answer)
    link_to("unvote", unvote_answer_path(answer),
      method: :delete,
      remote: true,
      id: "unvote-answer-#{answer.id}",
      class: 'vote_answer btn btn-default pull-left',
      data:{ type: :html, answer_id: answer.id }
    )
  end
end
