class SubscriptionsController < ApplicationController
  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    @subscription = Subscription.create(question: @question, user: current_user)
    respond_with(@subscription)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    render status: 403 unless current_user.author_of?(@subscription)
    respond_with(@subscription.destroy)
  end
end
