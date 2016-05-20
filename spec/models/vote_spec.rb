require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_uniqueness_of(:user_id).
      scoped_to(:question_id).with_message("You have already voted") }

end
