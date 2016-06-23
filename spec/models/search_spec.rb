require 'rails_helper'

RSpec.describe Search, type: :sphinx do
  describe '.find' do
    let!(:question1) { create(:question, title: 'findme', body: 'body') }
    let!(:question2) { create(:question, title: 'title', body: 'findme') }
    let!(:question3) { create(:question, title: 'notme', body: 'notme') }
    let!(:answer1) { create(:answer, body: 'findme') }
    let!(:answer2) { create(:answer, body: 'notme') }
    
    before(:each) do
      index
    end

    context 'when valid arguments' do
      it 'returns requested objects' do
        expect(Search.find('find', 'everywhere')).to match_array [question2, question1, answer1]
      end
      it 'returns requested questions' do
        expect(Search.find('find', 'questions')).to match_array [question2, question1]
      end
      it 'returns requested answers' do
        expect(Search.find('find', 'answers')).to match_array [answer1]
      end
    end

    context 'when invalid arguments'
      it 'returns empty array' do
        expect(Search.find('find', 'invalid')).to match_array []
      end
  end
end
