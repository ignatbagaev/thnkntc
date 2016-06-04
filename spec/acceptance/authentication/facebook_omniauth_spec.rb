require_relative '../acceptance_helper'

feature "log in through facebook" do
  
  scenario "can sign in user with facebook account" do
    visit new_user_session_path
    expect(page).to have_content("Sign in with Facebook")
    mock_auth_hash
    click_link "Sign in"
    expect(page).to have_content("Log out")
  end

  scenario "can handle authentication error" do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit new_user_session_path
    expect(page).to have_content("Sign in with Facebook")
    click_link "Sign in"
    expect(page).to have_content('Could not authenticate you from Facebook')
  end
end
