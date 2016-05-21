FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password '12345678'
  end

  factory :another_user, class: 'User' do
    email { Faker::Internet.email }
    password '12345678'
  end
end
