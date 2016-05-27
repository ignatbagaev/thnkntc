require_relative '../acceptance_helper'

feature 'create comment' do
  let(:user) { create :user }
  let(:question) { create(:question, user: user)}
  let(:answer) { create(:answer)}

  scenario 'guest could not comment' do
    visit question_path(question)
    expect(page).to_not have_link("comment on question")
  end

  scenario 'under question', js: true do
    log_in user
    visit question_path(question)
    within('div.question-item') do
      click_link 'add comment'
      fill_in 'comment[body]', with: "Comment"
      click_button "Add comment"
      expect(page).to have_content("Comment")
    end
  end

  scenario 'under answer', js: true do
    log_in user
    question.answers << answer
    visit question_path(question)
    within('div.answers') do
      click_link 'add comment'
      fill_in 'comment[body]', with: "Answer comment"
      click_button "Add comment"
      expect(page).to have_content("Answer comment")
    end
  end
end
