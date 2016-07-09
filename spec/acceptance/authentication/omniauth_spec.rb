require_relative '../acceptance_helper'

feature 'through facebook' do

  scenario 'can sign in user with facebook account' do
    visit new_user_session_path
    mock_facebook_auth_hash
    page.find(:xpath, "//a[contains(@href,'auth/facebook')]").click
    expect(page).to have_content('Log out')
  end

  scenario 'can handle authentication error' do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit new_user_session_path
    page.find(:xpath, "//a[contains(@href,'auth/facebook')]").click
    expect(page).to have_content('Could not authenticate you from Facebook')
  end
end

feature 'through twitter' do
  
  scenario 'can sign UP user with twitter account' do
    visit new_user_session_path
    mock_twitter_auth_hash
    page.find(:xpath, "//a[contains(@href,'auth/twitter')]").click
    fill_in 'email', with: 'email@example.com'
    click_button 'submit'
    expect(page).to have_content('Log out')
  end

  given(:user) { create :user }
  given(:auth) { create(:authorization, provider: 'twitter', uid: '123456', user: user) }
  scenario 'can sign IN user with twitter account' do
    user.authorizations << auth
    mock_twitter_auth_hash
    visit new_user_session_path
    page.find(:xpath, "//a[contains(@href,'auth/twitter')]").click
    expect(page).to have_content('Log out')
  end

  scenario 'can handle authentication error' do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    visit new_user_session_path
    page.find(:xpath, "//a[contains(@href,'auth/twitter')]").click
    expect(page).to have_content('Could not authenticate you from Twitter')
  end
end
