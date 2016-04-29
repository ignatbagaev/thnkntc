FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
    association :user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end