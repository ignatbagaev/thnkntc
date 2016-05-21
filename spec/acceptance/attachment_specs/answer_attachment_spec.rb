require_relative '../acceptance_helper'

feature 'add one or more attachments to answer' do
  given(:user) { create :user }
  given(:question) { create :question }

  scenario 'while create answer', js: true do
    log_in user
    visit question_path(question)
    within('div.new-answer-form') do
      fill_in :new_answer_body, with: 'Answer body'
      within('div.answer-attachments') do
        within('div.fields:first-child') do
          attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
        end
        click_link 'One more file'
        within('div.fields:nth-child(2)') do
          attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        end
      end
      click_button 'Send'
    end
    expect(page).to have_link('rails_helper.rb')
    expect(page).to have_link('spec_helper.rb')
  end
end
