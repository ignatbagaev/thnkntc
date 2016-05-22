module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    vote
  end

  def downvote
    vote
  end

  def unvote
    @votable.votes.find_by(user_id: current_user.id).destroy
    render_json_with_rating
  end

  private

  def vote
    unless current_user.author_of?(@votable)
      value = action_name == 'upvote' ? 1 : -1
      @vote = @votable.votes.new(value: value, user_id: current_user.id)
      if @vote.save
        @votable.update_rating
        render_json_with_rating
      else
        render_error
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def render_json_with_rating
    render json: @votable.rating
  end

  def render_error
    render json: @vote.errors, status: 422
  end
end
