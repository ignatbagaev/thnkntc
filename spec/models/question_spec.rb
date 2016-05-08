require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should respond_to(:has_accepted_answer?)}

  let(:question) { create :question }
  let(:answer) { create :answer}
  let(:accepted_answer) { create :accepted_answer }

  it 'returns true if question has accepted answer' do
    question.answers << accepted_answer
    expect(question.has_accepted_answer?).to eq true
  end
  
  it 'returns false if question has accepted answer' do
    question.answers << answer
    expect(question.has_accepted_answer?).to eq false
  end
end
