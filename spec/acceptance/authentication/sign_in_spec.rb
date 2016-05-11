require_relative '../acceptance_helper'

feature 'user logs in' do
  
  given(:user) { create :user }
  
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