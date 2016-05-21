require_relative '../acceptance_helper'

feature 'vote for answer' do
  let(:user) { create :user }
  let(:user2) { create :user }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user2) }
  let(:vote) { create(:vote)}

  scenario 'guest could not vote' do
    visit question_path(question)
    expect(page).to_not have_link("upvote")
  end

  scenario "user could upvote for another's answer", js: true do
    log_in user
    question.answers << answer
    visit question_path(question)
    click_link("upvote")
    expect(page).to have_content('rating: 1')
  end

  scenario "user could downvote for another's answer", js: true do
    log_in user
    question.answers << answer
    visit question_path(question)
    click_link("downvote")
    expect(page).to have_content('rating: -1')
  end

  scenario "user could not vote for own answer", js: true do
    log_in user
    user.answers << answer
    question.answers << answer
    visit question_path(question)
    expect(page).to_not have_link('upvote')
    expect(page).to_not have_link('downvote')
  end

  scenario "user could not vote twice for answer", js: true do
    log_in user
    question.answers << answer
    user.votes << vote
    answer.votes << vote
    visit question_path(question)
    expect(page).to_not have_link('upvote')
    expect(page).to_not have_link('downvote')
    expect(page).to have_link('unvote')
  end

  scenario "user could unvote answer", js: true do
    log_in user
    question.answers << answer
    user.votes << vote
    answer.votes << vote
    visit question_path(question)
    click_link('unvote')
    within('div.answers') do
      expect(page).to have_content("rating: 0")
    end
  end
end
