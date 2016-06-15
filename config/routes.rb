Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    post 'oauth/finish_signin', to: 'users/omniauth_callbacks#finish_signin'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create], shallow: true do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end

  root 'questions#index'
  
  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :unvote
    end
  end
  
  resources :questions, concerns: :votable do
    resources :comments
    resources :answers, concerns: :votable, shallow: true do
      resources :comments
      post :accept, on: :member
    end
  end

  resources :attachments, only: :destroy
end
