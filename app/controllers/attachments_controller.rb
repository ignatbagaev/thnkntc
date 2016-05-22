class AttachmentsController < ApplicationController
  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
    else
      render head: 403
    end
  end
end
