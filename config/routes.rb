Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }

  resources :users, except: [:index]

  resources :posts do
    collection do
      post 'upload_image'
      delete 'remove_image'
    end

    member do
      patch 'publish'
      patch 'unpublish'
    end
  end

  root to: 'home#index'
end
