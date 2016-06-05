require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET #facebook' do

    context 'when no oauth_data' do
      before do
        get :facebook
      end
      it 'should redirect_to new user registration' do
        expect(response).to redirect_to new_user_registration_path
      end
    end

    context 'when user exists' do  
      let(:user) { create :user }
      
      before do
        stub_env_for_omniauth(info: { email: user.email })
        get :facebook
      end
      it { should be_user_signed_in }
      it { should redirect_to root_path }
    end

    context 'when user not exists' do

      context 'email is provided' do
        before do
          stub_env_for_omniauth
          get :facebook
        end
        it { should be_user_signed_in }
        it { should redirect_to root_path }
      end

      context 'email is not provided' do
        before do
          stub_env_for_omniauth(info: nil)
          get :facebook
        end

        it 'stores data in session' do
          hash = stub_env_for_omniauth
          expect(session["devise.omniauth"][:provider]).to eq hash.provider
          expect(session["devise.omniauth"][:uid]).to eq hash.uid
        end

        it { should_not be_user_signed_in }
        it { should render_template 'oauth/provide_email' }
      end
    end    
  end

  describe 'GET #twitter' do
    context 'when no oauth_data' do
      before do
        get :twitter
      end
      it 'should redirect_to new user registration' do
        expect(response).to redirect_to new_user_registration_path
      end
    end

    context 'when user exists' do  
      let(:user) { create :user }
      
      before do
        stub_env_for_omniauth(provier: 'twitter', info: { email: user.email })
        get :twitter
      end
      it { should be_user_signed_in }
      it { should redirect_to root_path }
    end

    context 'when user not exists' do

      context 'when email is provided' do
        before do
          stub_env_for_omniauth(provier: 'twitter')
          get :twitter
        end
        it { should be_user_signed_in }
        it { should redirect_to root_path }
      end

      context 'when email is not provided' do
        before do
          stub_env_for_omniauth(provier: 'twitter', info: nil)
          get :twitter
        end

        it 'stores data in session' do
          hash = stub_env_for_omniauth(provier: 'twitter')
          expect(session["devise.omniauth"][:provider]).to eq hash.provider
          expect(session["devise.omniauth"][:uid]).to eq hash.uid
        end

        it { should_not be_user_signed_in }
        it { should render_template 'oauth/provide_email' }
      end
    end    
  end

  describe 'POST #finish_signin' do
    let(:user) { create :user }

    context 'when there is user with same email' do
      before { post :finish_signin, email: user.email }

      it { should_not be_user_signed_in }
      it { should render_template 'oauth/provide_email' }
    end

    context 'when invalid email' do
      before { post :finish_signin, email: nil }

      it { should_not be_user_signed_in }
      it { should render_template 'oauth/provide_email' }
    end

    context 'when valid email' do
      before do
        session["devise.omniauth"] = stub_env_for_omniauth(info: nil)
        post :finish_signin, email: 'valid@email.com'
      end

      it { should be_user_signed_in }
      it { should redirect_to root_path }
    end
  end

  def stub_env_for_omniauth(hash = {})
    hash = OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'user@test.com' }).merge(hash)
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[hash.provider.to_sym] = hash
  end
end
