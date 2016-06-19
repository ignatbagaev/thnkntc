class SubscriptionsController < ApplicationController
  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    respond_with(@subscription = Subscription.create(question: @question, user: current_user))
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    render status: 403 unless current_user.author_of?(@subscription)
    respond_with(@subscription.destroy)
  end
end
