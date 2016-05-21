module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    unless current_user.author_of?(@votable)
      @vote = @votable.votes.new(positive: true, user_id: current_user.id)
      @vote.save ? render_json_with_rating : render_error
    end
  end

  def downvote
    unless current_user.author_of?(@votable)
      @vote = @votable.votes.new(positive: false, user_id: current_user.id)
      @vote.save ? render_json_with_rating : render_error
    end
  end

  def unvote
    @votable.votes.find_by(user_id: current_user.id).destroy
    render_json_with_rating
  end

  private

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
