class AnswersController < ApplicationController
  before_action :load_question
  before_action :load_answer, only: :destroy
  
  def create
    @answer = @question.answers.new answer_params
    success or error
  end

  def destroy
    @answer.destroy if @answer.user == current_user
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body).merge(user: current_user)
  end

  def success
    redirect_to @question, notice: "Thank you for reply!" if @answer.save
  end

  def error
    redirect_to @question
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
