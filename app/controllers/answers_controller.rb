class AnswersController < ApplicationController
  include Voted
  include Authored
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :accept]
 
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    check_author(@answer) { @answer.update(answer_params) }
  end

  def destroy
    check_author(@answer) { @answer.destroy }
  end

  def accept
    check_author(@answer.question) { @answer.accept! }
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
