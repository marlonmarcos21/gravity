Rails.application.routes.draw do
  Rails.application.routes.default_url_options[:host] = Rails.application.config.action_mailer.default_url_options[:host].freeze

  devise_for :users, controllers: { sessions: 'sessions', passwords: 'passwords' }

  resources :users, except: [:index] do
    member do
      get 'more_published_posts'
      get 'more_published_blogs'
      get 'more_drafted_blogs'
      patch 'send_friend_request'
      patch 'accept_friend_request'
      patch 'reject_friend_request'
      patch 'cancel_friend_request'
    end
  end

  resources :posts do
    collection do
      post 'upload_media'
      delete 'remove_media'
      get 'more_published_posts'
      get 'presigned_url'
      get 'image_upload_callback'
      get 'pre_post_check'
    end

    member do
      patch 'editable'
      patch 'like'
      patch 'unlike'
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
      patch 'like'
      patch 'unlike'
    end
  end

  resources :comments, only: [:create, :destroy] do
    member do
      patch 'editable'
      patch 'like'
      patch 'unlike'
    end
  end

  get 'search', to: 'search#search'
  get 'about',  to: 'about#index'

  root to: 'posts#index'
end
