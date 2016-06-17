require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do
    it_behaves_like 'API unauthenticated'

    context 'when user authenticated' do
      let(:access_token) { create :access_token }
      let!(:questions) { create_list(:question, 2) }

      before { do_request(access_token: access_token.token) }

      it 'returns status 200' do
        expect(response.status).to eq 200
      end

      it 'returns collection of questions' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr} in question" do
          question = questions.last
          expect(response.body)
            .to be_json_eql(question.send(attr.to_sym).to_json)
            .at_path("questions/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let(:question) { create :question }

    it_behaves_like 'API unauthenticated'

    context 'when user authenticated' do
      let(:access_token) { create :access_token }
      let(:comments) { create_list(:comment, 2) }
      let(:attachments) { create_list(:attachment, 2) }

      before do
        question.comments << comments
        question.attachments << attachments
        do_request(access_token: access_token.token)
      end

      it 'returns status 200' do
        expect(response.status).to eq 200
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr} in question" do
          expect(response.body)
            .to be_json_eql(question.send(attr.to_sym).to_json)
            .at_path("question/#{attr}")
        end
      end

      context 'comments' do
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr} in comment" do
            comment = comments.last
            expect(response.body)
              .to be_json_eql(comment.send(attr.to_sym).to_json)
              .at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'contains url for each question attachment' do
          attachment = attachments.last
          expect(response.body)
            .to be_json_eql(attachment.file.url.to_json)
            .at_path('question/attachments/0/url')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API unauthenticated'

    context 'when user is authenticated' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }
      context 'valid params' do
        it 'returns status 201' do
          do_request(question: attributes_for(:question), access_token: access_token.token)
          expect(response.status).to eq 201
        end

        it 'returns attributes of created question' do
          do_request(question: { title: 'Title', body: 'Body' }, access_token: access_token.token)
          expect(response.body).to be_json_eql({ title: 'Title', body: 'Body' }.to_json).at_path('question')
        end

        it 'saves questions to database' do
          expect { do_request(question: attributes_for(:question), access_token: access_token.token) }
            .to change(user.questions, :count).by(1)
        end
      end

      context 'invalid params' do
        it 'returns status 422' do
          do_request(question: attributes_for(:invalid_question), access_token: access_token.token)
          expect(response.status).to eq 422
        end

        it 'does not saves questions to database' do
          expect { do_request(question: attributes_for(:invalid_question), access_token: access_token.token) }
            .to_not change(Question, :count)
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end
  end
end
