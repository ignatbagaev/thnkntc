class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, except: :create
  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    @question = @answer.question
    if current_user.author_of? @answer
      @answer.update(answer_params)
    else
      render nothing: true, status: 401
    end
  end

  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      render nothing: true, status: 401
    end
  end

  def accept
    question = @answer.question
    if current_user.author_of? question
      @answer.accept!
    else
      render nothing: true, status: 401
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
end
