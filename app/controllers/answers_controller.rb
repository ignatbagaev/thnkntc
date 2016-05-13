class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, except: :create
  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    if current_user.author_of? @answer
      @question = @answer.question
      @answer.update(answer_params)
    end
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def accept
    question = @answer.question
    @answer.accept! if current_user.author_of? question
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
end
