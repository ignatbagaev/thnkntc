class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, except: :create
  def create
    @answer = Answer.new(answer_params.merge(user: current_user, question: @question))
    @answer.save
  end

  def update
    if current_user.author_of? @answer
      @answer.update(answer_params)
      @question = @answer.question
    end
  end


  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def accept
    if current_user.author_of? @answer.question
      @answer.question.answers.each do |answer|
        answer.update_attribute(:status, 0)
      end
      @answer.update_attribute(:status, 1)
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
