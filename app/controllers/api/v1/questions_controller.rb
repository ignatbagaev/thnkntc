module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      authorize_resource

      def index
        @questions = Question.all
        respond_with @questions, each_serializer: Questions::IndexSerializer
      end

      def show
        @question = Question.find(params[:id])
        respond_with @question, serializer: Questions::ShowSerializer
      end

      def create
        @question = current_resource_owner.questions.create(question_params)
        respond_with @question, serializer: Questions::CreateSerializer
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
