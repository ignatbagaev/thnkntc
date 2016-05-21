require_relative '../acceptance_helper'

feature 'user signs up' do
  given(:user) { create :user }

  scenario 'with valid email and password' do
    sign_up_with('test@email.com', 'password')
    expect(current_path).to eq root_path
    expect(page).to have_content('Welcome')
  end

  scenario 'with invalid email' do
    sign_up_with('foo', 'password')
    expect(page).to have_content('Email is invalid')
    expect(current_path).to eq user_registration_path
  end

  scenario 'with invalid password' do
    sign_up_with('test@email.com', 'foo')
    expect(page).to have_content('short')
    expect(current_path).to eq user_registration_path
  end

  scenario 'with already taken email' do
    sign_up_with(user.email, 'password')
    expect(page).to have_content('Email has already been taken')
    expect(current_path).to eq user_registration_path
  end
end
