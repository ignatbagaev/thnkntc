class AnswersController < ApplicationController
  include Voted

  before_action :load_answer, only: [:update, :destroy, :accept]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    user_owns?(@answer) ? @answer.update(answer_params) : (render head: 403)
  end

  def destroy
    user_owns?(@answer) ? @answer.destroy : (render head: 403)
  end

  def accept
    user_owns?(@answer.question) ? @answer.accept! : (render head: 403)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
