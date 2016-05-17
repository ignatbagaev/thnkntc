require_relative '../acceptance_helper'

feature 'add one or more attachments to question' do
  
  given(:user) { create :user }

  scenario 'while create question', js: true do
    log_in user
    visit new_question_path
    fill_in 'Title', with: "Question title"
    fill_in 'Body', with: "Question body"
    within('div.fields:first-child') do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end   
    click_link "One more file"
    within('div.fields:nth-child(2)') do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_button 'Ask'
    expect(page).to have_link("rails_helper.rb")
    expect(page).to have_link("spec_helper.rb")
  end
end
