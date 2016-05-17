require_relative '../acceptance_helper'

feature 'delete attachment while update question or answer' do

  given(:user) { create :user }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:attachment1) { create(:attachment, attachable: question) }
  given(:attachment2) { create(:attachment, attachable: answer) }

  
  scenario 'user could delete own question attachment', js: true do
    log_in user
    filename = attachment1.file.filename
    visit question_path(question)
    click_link("Edit question")
    click_link("Remove this file")
    click_button("Update")
    expect(page).to_not have_link(filename)
  end

  scenario 'user could delete own answer attachment', js: true do
    log_in user
    filename = attachment2.file.filename
    visit question_path(question)
    click_link("Edit answer")
    click_link("Remove this file")
    click_button "Save"
    expect(page).to_not have_link(filename)
  end
end
