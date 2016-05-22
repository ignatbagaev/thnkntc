module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def update_rating
    update(rating: votes.pluck(:value).inject(0, :+))
  end
end
