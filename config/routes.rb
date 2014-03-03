require 'sidekiq/web'

Rails.application.routes.draw do
  root :to => 'home#index'

  devise_for :users, :controllers => { :registrations => 'users/registrations' }
  get 'teams' => 'teams#index', as: :user_root

  authenticate :user, lambda { |u| u.email == "davekaro@gmail.com" || u.email == "bhandari.sudershan@gmail.com" } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :teams, :except => [:show] do
    resources :practices, :except => [:show]
    resources :matches, :except => [:show] do
      member do
        get :availability_email
        get :lineup_email
      end
    end
    resources :match_availabilities, :only => [:index] do
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

