FactoryGirl.define do
  factory :vote do
    positive false
  end

  factory :positive_vote, class: 'Vote' do
    positive true
    user
  end

  factory :negative_vote, class: 'Vote' do
    positive false
    user
  end
end
