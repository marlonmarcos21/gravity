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

  resources :blogs do
    collection do
      post 'tinymce_assets'
    end

    member do
      patch 'publish'
      patch 'unpublish'
    end
  end

  get 'search', to: 'search#search'

  root to: 'home#index'
end
