require 'sidekiq/web'

Rails.application.routes.draw do
  root :to => 'home#index'

  devise_for :users, :controllers => { :registrations => 'users/registrations' }
  get 'teams' => 'teams#index', as: :user_root

  authenticate :user, lambda { |u| u.email == "davekaro@gmail.com" || u.email == "bhandari.sudershan@gmail.com" } do
    mount Sidekiq::Web => '/sidekiq'
  end

  if Rails.env.development? || Rails.env.try_it?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
    get 'try_it_sign_in' => 'try_it#auto_sign_in'
  end

  namespace :admin do
    resources :users, :only => [:index] do
      member do
        get :become
      end
    end
  end

  resources :teams, :except => [:show] do
    resources :practices, :except => [:show] do
      member do
        get :availability_email
      end
    end
    resources :matches, :except => [:show] do
      member do
        get :availabilities
        get :availability_email
        get :player_request_email
        get :lineup_email
      end
    end
    resources :match_availabilities, :only => [:index] do
      collection do
        get :set_availability
      end
    end
    resources :practice_sessions, :only => [] do
      collection do
        get :set_availability
      end
    end
    resources :results, :only => [:index]
    resources :team_members, :only => [:index, :edit, :update] do
      collection do
        get 'new', as: :new
        post 'create', as: :create
      end
      member do
        post 'send_welcome_email'
      end
    end
    member do
      post 'send_welcome_email'
    end
  end

  resources :practices, :only => [] do
    resources :practice_sessions, :only => [:create, :update]
    member do
      post 'notify'
    end
  end

  resources :matches, :only => [] do
    resources :match_availabilities, :only => [:create, :update]
    member do
      post 'notify'
      post 'notify_player_request'
      post 'notify_lineup'
      get 'edit_lineup' => 'match_lineups#edit'
      get 'edit_results' => 'results#edit'
    end
  end

  namespace :api do
    post 'postmark/inbound' => 'postmark#inbound'
    post 'postmark/bounce'  => 'postmark#bounce'
  end
end

