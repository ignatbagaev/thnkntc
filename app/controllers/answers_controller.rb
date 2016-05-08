class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, except: :create
  def create
    @answer = Answer.new(answer_params.merge(user: current_user, question: @question))
    @answer.save
  end

  def edit
    current_user.author_of?(@answer) ? (render :edit) : (redirect_to @answer.question)
  end

  def update
    update_answer or render :edit
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def accept
    if current_user.author_of? @answer.question
      @answer.update_attribute(:status, "accepted") unless @answer.question.has_accepted_answer?
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def update_answer
    if current_user.author_of? @answer
      @answer.update(answer_params) ? (redirect_to @answer.question) : (render :edit)
    end
  end
end
