FactoryGirl.define do
  factory :vote do
    value(-1)
  end

  factory :positive_vote, class: 'Vote' do
    value 1
    user
  end

  factory :negative_vote, class: 'Vote' do
    value(-1)
    user
  end
end
