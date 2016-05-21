require_relative '../acceptance_helper'

feature 'delete attachment' do
  given(:user) { create :user }
  given(:user2) { create :user }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:question_attachment) { create(:attachment) }
  given(:answer_attachment) { create(:attachment) }

  before do
    question.attachments << question_attachment
    answer.attachments << answer_attachment
  end

  scenario 'guest could not delete any file' do
    visit question_path(question)
    expect(page).to_not have_link('Delete file')
  end

  scenario 'user could delete own question attachment', js: true do
    log_in user
    visit question_path(question)

    within('div.question') do
      click_link('Delete file')
      expect(page).to_not have_link(question_attachment.file.filename)
    end
  end

  scenario 'user could delete own answer attachment', js: true do
    log_in user
    visit question_path(question)

    within("div#answer-#{answer.id}") do
      click_link('Delete file')
      expect(page).to_not have_link(answer_attachment.file.filename)
    end
  end

  scenario 'user could not delete anothers question attachment' do
    log_in user2
    visit question_path(question)

    within('div.question') do
      expect(page).to have_content(question_attachment.file.filename)
      expect(page).to_not have_link('Delete file')
    end
  end

  scenario 'user could not delete anothers answer attachment' do
    log_in user2
    visit question_path(question)

    within("div#answer-#{answer.id}") do
      expect(page).to have_content(answer_attachment.file.filename)
      expect(page).to_not have_link('Delete file')
    end
  end
end
