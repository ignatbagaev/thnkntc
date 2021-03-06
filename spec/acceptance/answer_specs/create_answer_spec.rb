require_relative '../acceptance_helper'

feature 'create answers', '
  In order to help with solving issues
  As user
  I want to be able to create answers
' do
  given(:user) { create :user }
  given(:question) { create :question }

  scenario 'unless user logged in' do
    visit question_path(question)
    expect(page).to_not have_content('New answer')
  end

  scenario 'with valid attributes if user logged in', js: true do
    log_in user
    visit question_path(question)
    fill_in :new_answer_body, with: 'Some long text'
    click_on 'Send'

    expect(page).to have_content('Some long text')
    expect(current_path).to eq question_path(question)
  end

  scenario 'with invalid attributes', js: true do
    log_in user
    visit question_path(question)
    fill_in :new_answer_body, with: nil
    click_on 'Send'
    expect(current_path).to eq question_path(question)
  end
end
