module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end


  def vote!(action, user)
    transaction do
      if action == 'unvote'
        vote = votes.find_by(user_id: user.id)
        if vote
          value = vote.value
          vote.destroy && update(rating: (rating - value))
        end
      else
        value = action == 'upvote' ? 1 : -1
        votes.create(value: value, user: user)
        update(rating: (rating + value))
      end
    end
  end
end
