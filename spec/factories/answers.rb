FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswerText#{n}" }
    question
    user
  end

end