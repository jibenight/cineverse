Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root
  root "home#index"

  # Movies
  resources :movies, only: [:index, :show] do
    member do
      post :toggle_watchlist
      post :toggle_release_alert
    end
    resources :ratings, only: [:create, :update, :destroy] do
      member do
        post :like
        delete :unlike
      end
    end
  end

  # Import from TMDb
  post "movies/import/:tmdb_id", to: "movies#import_tmdb", as: :import_tmdb_movie

  # Movie sections
  get "now-playing", to: "movies#now_playing", as: :now_playing
  get "upcoming", to: "movies#upcoming", as: :upcoming_movies
  get "trending", to: "movies#trending", as: :trending
  get "calendar", to: "movies#calendar", as: :calendar
  get "search", to: "search#index", as: :search

  # Cast members
  resources :cast_members, only: [:show], path: "actors"

  # Profiles
  resources :users, only: [:show], path: "profile", param: :username do
    member do
      post :follow
      delete :unfollow
    end
    resources :ratings, only: [:index], controller: "users/ratings"
  end

  # Watchlist
  resource :watchlist, only: [:show] do
    patch :reorder
  end

  # Settings
  resource :settings, only: [:show, :update] do
    resources :cinema_passes, only: [:new, :create, :edit, :update, :destroy], module: :settings
    resources :user_discounts, only: [:new, :create, :edit, :update, :destroy], module: :settings, path: "discounts"
  end

  # Chat
  resources :conversations, only: [:index, :show, :create, :destroy] do
    resources :messages, only: [:create]
    member do
      post :add_participant
      delete :remove_participant
      patch :mark_as_read
      post :leave
    end
  end

  # Notifications
  resources :notifications, only: [:index] do
    collection do
      post :mark_all_read
    end
  end

  # Newsletter
  namespace :newsletter do
    post :subscribe, to: "subscriptions#subscribe"
    get "confirm/:token", to: "subscriptions#confirm", as: :confirm
    get "unsubscribe/:token", to: "subscriptions#unsubscribe", as: :unsubscribe
    get "preferences/:token", to: "subscriptions#preferences", as: :preferences
    patch "preferences/:token", to: "subscriptions#update_preferences"
    get "click/:token", to: "tracking#click", as: :click
    get "open/:token", to: "tracking#open", as: :open
  end

  # Deals
  get "deals", to: "deals#index"

  # Affiliate redirect
  get "affiliate/redirect", to: "affiliate_redirects#show"

  # Reports
  resources :reports, only: [:create]

  # Static pages
  get "about", to: "static_pages#about"
  get "contact", to: "static_pages#contact"
  post "contact", to: "static_pages#send_contact"
  get "faq", to: "static_pages#faq"
  get "privacy", to: "static_pages#privacy"
  get "terms", to: "static_pages#terms"

  # Admin
  namespace :admin do
    root to: "dashboard#index"

    resources :users, only: [:index, :show, :edit, :update] do
      member do
        post :ban
        post :unban
        post :promote_admin
        post :promote_premium
        post :remove_premium
        delete :delete_account
      end
      collection do
        get :export_csv
      end
    end

    namespace :newsletter do
      resources :campaigns do
        member do
          post :send_campaign
          post :cancel
          post :duplicate
          post :send_test
          get :preview
        end
      end
      resources :subscribers, only: [:index, :show, :destroy] do
        member do
          post :unsubscribe
          post :resend_confirmation
        end
        collection do
          get :export_csv
          post :import_csv
        end
      end
      resources :templates, only: [:index, :new, :create, :edit, :update, :destroy] do
        member do
          get :preview
        end
      end
    end

    resources :affiliates, only: [:index] do
      collection do
        get :export_csv
      end
    end

    namespace :moderation do
      resources :reports, only: [:index, :show, :update] do
        member do
          post :dismiss
          post :hide_content
          post :delete_content
          post :warn_user
          post :mute_user
          post :ban_user
        end
      end
      resources :mutes, only: [:index, :destroy]
    end

    namespace :content do
      resources :movies, only: [:index, :show] do
        member do
          post :sync
          post :hide
        end
        collection do
          post :sync_all
        end
      end
      resources :static_pages, only: [:index, :edit, :update]
    end

    namespace :system do
      get :audit_log
      get :health
      get :tmdb_status
      get :newsletter_status
    end

    # Sidekiq Web UI
    require "sidekiq/web"
    require "sidekiq/cron/web"
    authenticate :user, ->(user) { user.admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end
  end
end
