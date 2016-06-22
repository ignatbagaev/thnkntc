class SearchController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @query = params[:query]
    @questions = Search.find(params[:query])
    respond_with @questions
  end
end
