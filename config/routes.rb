Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    post 'oauth/finish_signin', to: 'users/omniauth_callbacks#finish_signin'
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
