require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it do
    should validate_uniqueness_of(:user_id)
      .scoped_to(:votable_id, :votable_type).with_message('You have already voted')
  end
end
