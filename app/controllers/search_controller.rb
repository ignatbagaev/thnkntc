class SearchController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @query, @object = params[:query], params[:object]
    @results = Search.find(@query, @object)
    respond_with @result
  end
end
