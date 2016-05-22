class QuestionsController < ApplicationController
  include Voted

  skip_before_action :authenticate_user!, only: [:show, :index]
  before_action :load_question, only: [:edit, :show, :update, :destroy, :upvote, :downvote, :unvote]

  def new
    @question = Question.new
    @question.attachments.build
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def index
    @questions = Question.all
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))
    save_question || render('new')
  end

  def update
    user_owns?(@question) ? @question.update(question_params) : (render head: 403)
  end

  def destroy
    if user_owns?(@question)
      @question.destroy && redirect_to(questions_path)
    else
      redirect_to @question
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def save_question
    redirect_to @question, notice: 'Question successfuly created' if @question.save
  end
end
