class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: :create
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    check_owner(@answer) do 
      @answer.update(answer_params)
    end
  end

  def destroy
    check_owner(@answer) do 
      @answer.destroy
    end
  end

  def accept
    check_owner(@answer.question) do
      @answer.accept!
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def check_owner(object, &block)
    if current_user.author_of? object
      yield if block_given?
    else
      render nothing: true, status: 401
    end
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
