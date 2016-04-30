FactoryGirl.define do
  factory :answer do
    body "MyAnswerText"
    question
    user
  end
end