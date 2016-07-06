module QuestionsHelper
  def question_edit_link(question, content = "Edit")
    return unless can?(:update, question)
    link_to(content, [:edit, question], class: 'btn btn-default edit-question-link')
  end

  def question_destroy_link(question, content = "Delete question")
    return unless can?(:destroy, question)
    link_to(content, question, method: :delete, class: 'btn btn-default')
  end

  def link_to_upvote_question(question, content = "Upvote")
    return unless can?(:upvote, question)
    link_to(content, [:upvote, question],
      method: :post, remote: true, class: 'vote_question btn btn-default pull-left', data: { type: :html }
    )
  end

  def link_to_downvote_question(question, content = "Downvote")
    return unless can?(:downvote, question)
    link_to(content, [:downvote, question],
      method: :post, remote: true, class: 'vote_question btn btn-default pull-left', data: { type: :html }
    )
  end

  def link_to_unvote_question(question, content = "Unvote")
    return unless can?(:unvote, question)
    link_to(content, [:unvote, question],
      method: :delete, remote: true, class: 'vote_question btn btn-default pull-left', data: { type: :html }
    )
  end
end
