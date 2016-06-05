require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it do
    subject.user = FactoryGirl.build(:user)
    should validate_uniqueness_of(:user_id).scoped_to(:provider, :uid)
  end
end
