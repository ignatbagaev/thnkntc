FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "MyString#{n}" }
    body 'MyQuestionText'
    rating 0
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    rating 0
  end
end
