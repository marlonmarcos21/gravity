Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }
  resources :posts do
    collection do
      post 'upload_image'
      delete 'remove_image'
    end
  end
  root to: 'home#index'
end
