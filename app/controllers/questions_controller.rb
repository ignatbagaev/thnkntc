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
    if @question.save
      PrivatePub.publish_to "/questions", question: @question
      redirect_to @question
    else
      render('new')
    end
  end

  def update
    current_user.author_of?(@question) ? @question.update(question_params) : (render head: 403)
  end

  def destroy
    if current_user.author_of?(@question)
      PrivatePub.publish_to "/questions_destroying", question_id: @question.id
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
end
