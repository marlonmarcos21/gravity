Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }

  resources :users, except: [:index] do
    member do
      get 'more_published_posts'
      get 'more_drafted_posts'
      get 'more_published_blogs'
      get 'more_drafted_blogs'
    end
  end

  resources :posts do
    collection do
      post 'upload_image'
      delete 'remove_image'
      get 'more_published_posts'
    end

    member do
      patch 'publish'
      patch 'unpublish'
      patch 'editable'
    end
  end

  resources :blogs do
    collection do
      post 'tinymce_assets'
      get 'more_published_blogs'
    end

    member do
      patch 'publish'
      patch 'unpublish'
    end
  end

  resources :comments, only: [:create, :destroy]

  get 'search', to: 'search#search'

  root to: 'home#index'
end
