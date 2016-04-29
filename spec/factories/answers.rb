FactoryGirl.define do
  factory :answer do
    body "MyText"
    association :user
    association :question
  end
end