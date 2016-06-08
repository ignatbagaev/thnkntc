class QuestionsController < ApplicationController
  include Voted

  skip_before_action :authenticate_user!, only: [:show, :index]
  before_action :load_question, only: [:edit, :show, :update, :destroy, :upvote, :downvote, :unvote]
  before_action :check_author, only: [:update, :destroy]

  respond_to :js, only: :update
  
  authorize_resource

  def new
    respond_with(@question = Question.new)
  end

  def show
    @answer = @question.answers.build
    respond_with(@question)
  end

  def index
    respond_with(@questions = Question.all)
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
    PrivatePub.publish_to '/questions', question: @question if @question.valid?
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
    PrivatePub.publish_to '/questions_destroying', question: @question if @question.destroyed?
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def check_author
    return if current_user.author_of?(@question)
    if request.format.js? then (render status: 403)
    elsif request.format.html? then redirect_to questions_path
    end
  end
end
