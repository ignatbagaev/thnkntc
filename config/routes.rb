Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'
  resources :questions do
    member do
      post :upvote
      post :downvote
      delete :unvote
    end
    resources :answers, shallow: true do
      member do
        post :upvote
        post :downvote
        delete :unvote
    end
      post :accept, on: :member
    end
  end
  resources :attachments, only: :destroy
end
