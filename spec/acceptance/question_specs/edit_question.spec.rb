require_relative '../acceptance_helper'

feature 'edit own question', '
  In orderto fix my question
  As user
  I want to be able to edit my questions
' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'link to edit is visible only for question owner', js: true do
    log_in user2
    visit question_path(question)
    expect(page).to_not have_selector(:link, 'Edit question')
  end

  scenario 'update with valid attributes', js: true do
    log_in user
    visit question_path(question)
    click_link 'Edit'
    within"form#edit_question_#{question.id}" do
      fill_in 'Title', with: 'Edited title'
      fill_in 'Body', with: 'Edited body'
      click_button 'Update'
    end
    expect(current_path).to eq question_path(question)
    expect(page).to have_content('Edited title')
    expect(page).to have_content('Edited body')
  end

  scenario 'update with invalid attributes', js: true do
    log_in user
    visit question_path(question)
    click_link 'Edit'
    within"form#edit_question_#{question.id}" do
      fill_in 'Title', with: nil
      fill_in 'Body', with: nil
      click_button 'Update'
    end
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Title can\'t be blank'
    expect(page).to have_content 'Body can\'t be blank'
  end
end
