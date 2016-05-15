require_relative '../acceptance_helper'

feature 'add attachment to answer' do
  
  given(:user) { create :user }
  given(:question) { create :question }

  scenario 'while create answer', js: true do
    log_in user
    visit question_path(question)
    within('div.new-answer-form') do
      fill_in 'Body', with: "Answer body"
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_button 'Send'
    end
    expect(page).to have_link("rails_helper.rb")
  end
end