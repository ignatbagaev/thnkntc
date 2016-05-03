class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  
  def create
    @answer = Answer.new(answer_params.merge(user: current_user, question: @question))
    save_answer or render template: 'questions/show'
  end

  def destroy
    @answer = Answer.find(params[:id])
    destroy_answer
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def save_answer
    redirect_to @question, notice: "Thank you for reply!" if @answer.save
  end

  def destroy_answer
    @answer.destroy if current_user.author_of?(@answer)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
