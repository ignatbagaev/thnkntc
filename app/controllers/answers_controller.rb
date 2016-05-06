class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  
  def create
    @answer = Answer.new(answer_params.merge(user: current_user, question: @question))
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    destroy_answer
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def destroy_answer
    @answer.destroy if current_user.author_of?(@answer)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
