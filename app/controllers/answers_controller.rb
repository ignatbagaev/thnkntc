class AnswersController < ApplicationController
  include Voted

  before_action :load_answer, only: [:update, :destroy, :accept]

  respond_to :js

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def accept
    current_user.author_of?(@answer.question) ? respond_with(@answer.accept!) : (render head: 403)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
