class AnswersController < ApplicationController
  before_action :load_question
  
  def create
    @answer = @question.answers.new(answer_params)
    success or error
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def success
    redirect_to @question, notice: "Thank you for reply!" if @answer.save
  end

  def error
    render 'questions/show'
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
