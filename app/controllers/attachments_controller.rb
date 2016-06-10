class AttachmentsController < ApplicationController
  before_action :load_attachment
  before_action :check_author

  respond_to :js

  authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def check_author
    render status: 403 unless current_user.author_of?(@attachment.attachable)
  end
end
