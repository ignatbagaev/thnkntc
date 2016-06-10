class CommentsController < ApplicationController
  respond_to :js

  authorize_resource

  def create
    set_commentable
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
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
