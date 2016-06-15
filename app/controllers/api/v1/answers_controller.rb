module Api
  module V1
    class AnswersController < Api::V1::BaseController
      authorize_resource
      before_action :load_question

      def index
        @answers = @question.answers
        respond_with @answers
      end

      private

      def load_question
        @question = Question.find(params[:question_id])
      end
    end
  end
end
