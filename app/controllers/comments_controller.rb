class CommentsController < ApplicationController

  def create
    set_commentable
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
    @comment.save || (render head: 422)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    klass_name = request.original_fullpath.split('/')[1].singularize
    @commentable = klass_name.classify.constantize.find_by(id: params["#{klass_name}_id"])
  end
end
