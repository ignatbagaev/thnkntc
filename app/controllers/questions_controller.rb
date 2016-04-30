class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
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
    @question = Question.create question_params.merge(user: current_user)
    save_question or render 'new'
  end

  def destroy
    @question = Question.find(params[:id])
    delete_question or redirect_to @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def save_question
    redirect_to @question, notice: 'Question successfuly created' if @question.save
  end

  def delete_question
    if @question.user_id == current_user.id
      @question.destroy and redirect_to questions_path
    end
  end

  def load_question
    @question = Question.find(params[:id])
  end
end

