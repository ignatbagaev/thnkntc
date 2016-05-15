require_relative '../acceptance_helper'

feature 'delete attachment while update question or answer' do

  given(:user) { create :user }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user) }
  given(:attachment) { create :attachment }
  
  scenario 'user could delete own question attachment', js: true do
    log_in user
    question.attachments << attachment
    visit question_path(question)
    click_link("Edit question")
    click_link("Remove this file")
    click_button("Update")
    expect(page).to_not have_link(attachment.file.filename)
  end

  scenario 'user could delete own answer attachment', js: true do
    log_in user
    question.answers << answer
    answer.attachments << attachment
    filename = attachment.file.filename
    visit question_path(question)
    click_link("Edit answer")
    click_link("Remove this file")
    click_button "Save"
    expect(page).to_not have_link(filename)
  end

end