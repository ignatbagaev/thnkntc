class AnswersController < ApplicationController
  before_action :load_question
  
  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new answer_params.merge(question: @question)
    if @answer.save
      redirect_to @question
    else
      render 'new'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
