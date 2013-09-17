BreakpointApp::Application.routes.draw do
  root :to => 'teams#index'

  devise_for :users, :controllers => { :registrations => 'users/registrations' }

  resources :teams do
    resources :practices, :only => [:index, :new]
    resources :matches, :only => [:index, :new]
    resources :match_availabilities, :only => [:index]
    resources :results, :only => [:index]
    resources :team_members, :only => :index
    resources :invites, :only => [:index, :create, :update]
  end

  resources :practices, :except => [:index, :new] do
    resources :practice_sessions, :only => [:create, :destroy]
    member do
      post 'notify'
    end
  end

  resources :matches, :except => [:index, :new] do
    resources :match_availabilities, :only => [:create, :update]
    member do
      post 'notify'
      post 'notify_lineup'
      get 'edit_lineup' => 'match_lineups#edit'
      get 'edit_results' => 'results#edit'
    end
  end

  resources :team_members, :only => [:edit, :update]
end

