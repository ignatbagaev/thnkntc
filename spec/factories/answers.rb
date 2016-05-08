FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswerText#{n}" }
    status 0
    question
    user
  end

  factory :accepted_answer, class: 'Answer' do
    sequence(:body) { |n| "MyAnswerText#{n}" }
    status 1
    question
    user
  end
end