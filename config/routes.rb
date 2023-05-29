require 'sidekiq/web'

Rails.application.routes.draw do
  Rails.application.routes.default_url_options[:host] = Rails.application.config.action_mailer.default_url_options[:host].freeze

  devise_for :users, controllers: { sessions: 'sessions', passwords: 'passwords' }

  # rubocop:disable Style/Lambda
  authenticate :user, lambda { |u| u.id == 1 } do
    mount Sidekiq::Web => '/sidekiq'
  end
  # rubocop:enable Style/Lambda

  resources :users, except: [:index] do
    member do
      get   :more_published_posts
      get   :more_published_blogs
      get   :more_drafted_blogs
      get   :more_drafted_recipes
      patch :send_friend_request
      patch :accept_friend_request
      patch :reject_friend_request
      patch :cancel_friend_request
    end
  end

  resources :posts do
    collection do
      delete :remove_media
      get    :more_published_posts
      get    :presigned_url
      get    :media_upload_callback
      get    :pre_post_check
    end

    member do
      patch :editable
      patch :like
      patch :unlike
    end
  end

  resources :blogs do
    collection do
      post :tinymce_assets
      get  :more_published_blogs
    end

    member do
      patch :publish
      patch :unpublish
      patch :like
      patch :unlike
    end
  end

  resources :blog_categories, only: [] do
    member do
      get :blogs
      get :more_published_blogs
    end
  end

  resources :recipe_media, except: [:index]

  resources :recipes do
    collection do
      get :more_published_recipes
    end

    member do
      patch :publish
      patch :unpublish
    end
  end

  resources :recipe_categories, only: [] do
    member do
      get :recipes
      get :more_published_recipes
    end
  end

  resources :events, except: [:index] do
    member do
      post  :rsvp
      get   :rsvps
      patch :publish
      patch :unpublish
    end
  end

  resources :comments, only: [:create, :destroy] do
    member do
      patch :editable
      patch :like
      patch :unlike
    end
  end

  resources :chats, only: [:index, :show] do
    collection do
      get :conversations, constraints: { format: :json }
      get '/conversations/:id', to: 'chats#conversation', constraints: { format: :json }
    end
  end

  get :search, to: 'search#search'
  get :about,  to: 'about#index'

  get   :set_light_mode,      to: 'application#set_light_mode'
  get   :set_dark_mode,       to: 'application#set_dark_mode'
  patch :clear_notifications, to: 'application#clear_notifications'
  patch :clear_message_count, to: 'application#clear_message_count'

  root to: 'posts#index'
end
