require_relative '../acceptance_helper'

feature 'user can log out', '
  In order to destroy the session
  As user
  I want to be able to log out
' do
  given(:user) { create(:user) }

  scenario 'page have link to log out' do
    log_in user
    expect(page).to have_selector(:link_or_button, 'Log out')
  end

  scenario 'user could log out' do
    log_in user
    click_on 'Log out'
    expect(current_path).to eq root_path
    expect(page).to have_selector(:link_or_button, 'Sign in')
  end
end
