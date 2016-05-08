require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  let(:answer) { create :answer}
  let(:accepted_answer) { create :accepted_answer}
  let(:answer2) { create :answer}

  it "shows the accepted answer at the top of the list" do
    expect(accepted_answer).to eq Answer.first
  end
end
