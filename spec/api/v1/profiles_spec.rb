require 'rails_helper'

describe 'Profile API' do
  describe 'GET #me' do
    it_behaves_like 'API unauthenticated'

    context 'when user is authenticated' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(access_token: access_token.token) }

      it 'return status 200' do
        expect(response.status).to eq 200
      end

      %w(email id created_at updated_at).each do |key|
        it "respond contains #{key}" do
          expect(response.body).to be_json_eql(me.send(key.to_sym).to_json).at_path(key)
        end
      end

      %w(password encrypted_password).each do |key|
        it "respond does not contain #{key}" do
          expect(response.body).to_not have_json_path(key)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET #index' do
    it_behaves_like 'API unauthenticated'

    context 'when user is authenticated' do
      let(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }
      let!(:other_users) { create_list(:user, 5) }

      before { do_request(access_token: access_token.token) }

      it 'returns success' do
        expect(response.status).to eq 200
      end

      %w(id email created_at updated_at).each do |key|
        it "contains #{key}" do
          other_users.each_with_index do |user, index|
            expect(response.body).to be_json_eql(user.send(key).to_json).at_path("#{index}/#{key}")
          end
        end
      end

      %w(password encrypted_password).each do |key|
        it "does not contain #{key}" do
          other_users.each_with_index do |_user, index|
            expect(response.body).to_not have_json_path("#{index}/#{key}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', { format: :json }.merge(options)
    end
  end
end
