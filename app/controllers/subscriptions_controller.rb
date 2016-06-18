class SubscriptionsController < ApplicationController
  before_action :load_question

  respond_to :js

  def create
    respond_with(@subscription = Subscription.create(question: @question, user: current_user))
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

end
