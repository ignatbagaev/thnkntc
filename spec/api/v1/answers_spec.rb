require 'rails_helper'

describe 'Answers API' do
  let(:question) { create :question }
  describe 'GET #index' do
    let(:answers) { create_list(:answer, 2) }

    context 'when user is not authenticated' do
      it 'return status 401 if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end
    
    context 'when user is authenticated' do
      let(:access_token) { create :access_token }

      before do
        question.answers << answers
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token
      end

      it 'responds with status 200' do
        expect(response.status).to eq 200
      end

      it 'returns answers list for certain question' do
        puts response.body
        expect(response.body).to have_json_size(1)
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body question_id created_at updated_at).each do |attr|
        it "returns #{attr} for each answer" do
          answer = answers.first
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end
end
