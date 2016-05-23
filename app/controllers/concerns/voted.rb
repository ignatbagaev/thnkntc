module Voted
  extend ActiveSupport::Concern

  included do
    before_action :vote, only: [:upvote, :downvote, :unvote]
  end

  def upvote; end
  def downvote; end
  def unvote; end

  private

  def vote
    @votable = model_klass.find(params[:id])
    if current_user.author_of?(@votable)
      render head: 403
    else
      @votable.vote!(action_name, current_user) && render_rating || render_error
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def render_rating
    render json: @votable.rating
  end

  def render_error
    render head: 422
  end
end
