class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:edit, :show, :update, :destroy, :upvote, :downvote, :unvote]
  def new
    @question = Question.new
    @question.attachments.build
  end

  def show
    @answer = @question.answers.new
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
    update_question || render(head: 403)
  end

  def destroy
    delete_question || redirect_to(@question)
  end

  def upvote
    @vote = @question.votes.create(positive: true, user_id: current_user.id)
      respond_to do |format|
      if @vote.save
        format.json { render json: @question.rating }
      else
        format.json { render json: @vote.errors, status: 422 }
      end
    end
  end

  def downvote
    @vote = @question.votes.new(positive: false, user_id: current_user.id)
    respond_to do |format|
      if @vote.save
        format.json { render json: @question.rating }
      else
        format.json { render json: @vote.errors, status: 422 }
      end
    end
  end

  def unvote
    @question.votes.find_by(user_id: current_user.id).destroy
    respond_to do |format|
      format.json { render json: @question.rating }
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

  def update_question
    if current_user.author_of? @question
      @question.update(question_params)
    end
  end

  def delete_question
    return unless current_user.author_of? @question
    @question.destroy && redirect_to(questions_path)
  end
end
