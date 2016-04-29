require 'rails_helper'

feature 'user can log out', %q{
  In order to destroy the session
  As user
  I want to be able to log out
} do
  given(:user) { create(:user) }

  def log_in
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
  end

  scenario 'page have link to log out' do
    log_in
    expect(page).to have_selector(:link_or_button, "Log out")
  end

  scenario 'user could log out' do
    log_in
    click_on "Log out"
    expect(current_path).to eq root_path
    expect(page).to have_selector(:link_or_button, "Sign in")
  end
end