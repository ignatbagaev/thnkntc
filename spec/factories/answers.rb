FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswerText#{n}" }
    accepted false
    question
    user
  end

  factory :accepted_answer, class: 'Answer' do
    sequence(:body) { |n| "MyAnswerText#{n}" }
    accepted true
    question
    user
  end
end
