class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:edit, :show, :update, :destroy]
  def new
    @question = Question.new
  end

  def show
    @answer = Answer.new
  end

  def index
    @questions = Question.all
  end

  def create
    @question = Question.create(question_params.merge(user: current_user))
    save_question or render 'new'
  end

  def update
    @question.update(question_params) if current_user.author_of? @question
  end

  def destroy
    delete_question or redirect_to @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def save_question
    redirect_to @question, notice: 'Question successfuly created' if @question.save
  end

  def delete_question
    if current_user.author_of? @question
      @question.destroy and redirect_to questions_path
    end
  end
end
