module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end


  def vote!(action, user)
    transaction do
      action == 'unvote' ? delete_vote(action, user) : create_vote(action, user)
    end
  end

  private

  def create_vote(action, user)
    value = action == 'upvote' ? 1 : -1
    votes.create(value: value, user: user)
    update(rating: (rating + value))
  end

  def delete_vote(action, user)
    vote = votes.find_by(user_id: user.id)
    if vote
      value = vote.value
      vote.destroy && update(rating: (rating - value))
    end
  end
end
