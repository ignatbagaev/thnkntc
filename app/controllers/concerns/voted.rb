module Voted
  extend ActiveSupport::Concern

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
    (yield if block_given?) && render_rating || render_error
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
