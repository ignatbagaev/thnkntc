require_relative '../acceptance_helper'

feature 'best answer', %q{
  In order to tell others about answer solved my question
  As user
  I want to be able to flag answer as best
} do
  given(:user) { create :user }
  given(:user2) { create :user }
  given(:answers) { create_list(:answer, 2) }
  given(:question) { create(:question, user: user, answers: answers)}
  before(:each) { log_in user }

  scenario 'user could accept answer of question' do
    visit question_path(question)
    answers.each do |answer|
      expect(page).to have_button("Accept")
    end
  end

  scenario 'question owner accepts the answer', js: true do
    id_1 = question.answers.first.id
    visit question_path(question)
    page.find("#accept-#{id_1}").click
    within("#answer-row-#{id_1}") do
      expect(page).to_not have_button("Accept")
      expect(page).to have_content("Accepted")
    end
  end

  scenario 'user could not accept answer of another\'s question' do
    user2.questions << question
    visit question_path(question)
    expect(page).to_not have_button("Accept")
  end

  scenario 'question owner could change accepted answer', js: true do
    id_1 = question.answers.first.id
    id_2 = question.answers.last.id
    visit question_path(question)
    page.find("#accept-#{id_1}").click
    page.find("#accept-#{id_2}").click
    within("#answer-row-#{id_2}") do
      expect(page).to_not have_button("Accept")
      expect(page).to have_content("Accepted")
    end
  end

  scenario 'accepted answer at the top', js: true do
    id_1 = question.answers.first.id
    id_2 = question.answers.last.id
    visit question_path(question)
    page.find("#accept-#{id_1}").click
    page.find("#accept-#{id_2}").click
    within('.list-group-item:first-child') do
      expect(page).to have_content("Accepted")
    end
  end
end