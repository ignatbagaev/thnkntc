class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :provider, :uid, presence: true
  validates :user_id, uniqueness: { scope: [:provider, :uid] }
end
