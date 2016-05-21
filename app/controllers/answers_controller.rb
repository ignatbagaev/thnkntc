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

  def upvote
    @answer_vote = @answer.votes.create(positive: true, user_id: current_user.id)
    respond_to do |format|
      if @answer_vote.save
        format.json { render json: @answer.rating }
      else
        format.json { render json: @answer_vote.errors, status: 422 }
      end
    end
  end

  def downvote
    @answer_vote = @answer.votes.create(positive: false, user_id: current_user.id)
    respond_to do |format|
      if @answer_vote.save
        format.json { render json: @answer.rating }
      else
        format.json { render json: @answer_vote.errors, status: 422 }
      end
    end
  end

  def unvote
    @answer.votes.find_by(user_id: current_user.id).destroy
    respond_to do |format|
      format.json { render json: @answer.rating }
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
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
