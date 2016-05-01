module AnswersHelper
  def answers_of(question_id)
    Answer.where(question_id: question_id)
  end
end
