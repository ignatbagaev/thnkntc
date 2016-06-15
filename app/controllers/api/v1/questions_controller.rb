module Api
  module V1
    class QuestionsController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :doorkeeper_authorize!
      respond_to :json

      authorize_resource

      def index
        @questions = Question.all
        respond_with @questions
      end

      def show
        @question = Question.find(params[:id])
        respond_with @question
      end
    end
  end
end
