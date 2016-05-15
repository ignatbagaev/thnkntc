class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: :create
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    check_owner(@answer) { @answer.update(answer_params) }
  end

  def destroy
    check_owner(@answer) { @answer.destroy }
  end

  def accept
    check_owner(@answer.question) { @answer.accept! }
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def check_owner(object)
    if current_user.author_of? object
      yield if block_given?
    else
      render head: 403
    end
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
