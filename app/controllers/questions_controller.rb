class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
    @answer = @question.answers.build
  end

  def index
    @questions = Question.all
  end

  def create
    @question = Question.create(question_params)
    if @question.save
      flash[:notice] = 'Question successfuly created'
      redirect_to @question
    else
      render 'new'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
