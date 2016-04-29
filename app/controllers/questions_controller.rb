class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :index]
  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
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

  def destroy
    @question = Question.find(params[:id])
    if @question.user == current_user
      @question.destroy 
      redirect_to questions_path
    else
      redirect_to @question
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body).merge(user: current_user)
  end
end
