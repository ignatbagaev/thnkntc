require 'rails_helper'

feature 'user logs in' do
  
  given(:user) { create :user }

  def log_in_with(email, password)
    visit new_user_session_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_on "Log in"
  end

  scenario 'with valid email and valid password' do
    log_in_with(user.email, user.password)
    expect(page).to have_content("Signed in successfully")
    expect(current_path).to eq root_path  
  end

  scenario 'with invalid password' do
    log_in_with(user.email, 'foo')
    expect(page).to have_content("Invalid email or password")
    expect(current_path).to eq user_session_path   
  end 

  scenario 'with invalid email' do
    log_in_with('foo@bar.com', user.password)
    expect(page).to have_content("Invalid email or password")
    expect(current_path).to eq user_session_path   
  end
end