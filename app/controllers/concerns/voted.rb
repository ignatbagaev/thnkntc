module Voted
  extend ActiveSupport::Concern

  included do
    # before_action :vote, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    vote { @votable.upvote!(current_user) }
  end

  def downvote
    vote { @votable.downvote!(current_user) }
  end

  def unvote
    vote { @votable.unvote!(current_user) }
  end

  private

  def vote
    @votable = model_klass.find(params[:id])
    if current_user.author_of?(@votable)
      render head: 403
    else
      (yield if block_given?) && render_rating || render_error
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
