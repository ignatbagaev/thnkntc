require 'rails_helper'

describe 'Answers API' do
  let(:question) { create :question }
  describe 'GET #index' do
    it_behaves_like 'API unauthenticated'

    let(:answers) { create_list(:answer, 2) }

    context 'when user is authenticated' do
      let(:access_token) { create :access_token }

      before do
        question.answers << answers
        do_request(access_token: access_token.token)
      end

      it 'responds with status 200' do
        expect(response.status).to eq 200
      end

      it 'returns answers list for certain question' do
        expect(response.body).to have_json_size(1)
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body question_id created_at updated_at).each do |attr|
        it "returns #{attr} for each answer" do
          answer = answers.first
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let(:answer) { create(:answer, question: question) }

    it_behaves_like 'API unauthenticated'

    context 'when user is authenticated' do
      let(:access_token) { create :access_token }
      let(:comments) { create_list(:comment, 2) }
      let(:attachments) { create_list(:attachment, 2) }

      before do
        answer.comments << comments
        answer.attachments << attachments
        do_request(access_token: access_token.token)
      end

      it 'responds with status 200' do
        expect(response.status).to eq 200
      end

      %w(id body question_id created_at updated_at).each do |attr|
        it "contains #{attr} for requested answer" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr} in comment" do
            comment = comments.last
            expect(response.body)
              .to be_json_eql(comment.send(attr.to_sym).to_json)
              .at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'contains url for each question attachment' do
          attachment = attachments.last
          expect(response.body)
            .to be_json_eql(attachment.file.url.to_json)
            .at_path('answer/attachments/0/url')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    let(:question) { create :question }

    it_behaves_like 'API unauthenticated'

    context 'when user is authenticated' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }
      context 'valid params' do
        it 'returns status 201' do
          do_request(answer: attributes_for(:answer), access_token: access_token.token)
          expect(response.status).to eq 201
        end

        it 'returns attributes of created answer' do
          do_request(answer: { body: 'Body' }, access_token: access_token.token)
          expect(response.body).to be_json_eql({ body: 'Body' }.to_json).at_path('answer')
        end

        it 'saves answer to database' do
          expect { do_request(answer: attributes_for(:answer), access_token: access_token.token) }
            .to change(user.answers, :count).by(1)
        end
      end

      context 'invalid params' do
        it 'returns status 422' do
          do_request(answer: attributes_for(:invalid_answer), access_token: access_token.token)
          expect(response.status).to eq 422
        end

        it 'does not saves answer to database' do
          expect { do_request(answer: attributes_for(:invalid_answer), access_token: access_token.token) }
            .to_not change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end
