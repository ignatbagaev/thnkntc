Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :unvote
    end
  end
  
  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true do
      post :accept, on: :member
    end
  end

  resources :attachments, only: :destroy
end
