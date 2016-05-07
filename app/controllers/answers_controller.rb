class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  
  def create
    @answer = Answer.new(answer_params.merge(user: current_user, question: @question))
    @answer.save
  end

  def edit
    @answer = Answer.find(params[:id])
    current_user.author_of?(@answer) ? (render :edit) : (redirect_to @answer.question)
  end

  def update
    @answer = Answer.find(params[:id])
    update_answer or render :edit
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

  def load_question
    @question = Question.find(params[:question_id])
  end

  def update_answer
    if current_user.author_of? @answer
      @answer.update(answer_params) ? (redirect_to @answer.question) : (render :edit)
    end
  end

  def destroy_answer
    @answer.destroy if current_user.author_of?(@answer)
  end
end
