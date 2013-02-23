BreakpointApp::Application.routes.draw do
  root :to => 'teams#index'

  devise_for :users

  resources :teams do
    resources :practices, :only => [:index, :new]
    resources :matches, :only => [:index, :new]
    resources :team_members, :only => :index
    resources :invites, :only => [:index, :create, :update, :destroy]
  end

  resources :practices, :except => [:index, :new] do
    resources :practice_sessions, :only => [:create, :destroy]
    member do
      post 'notify'
    end
  end

  resources :matches, :except => [:index, :new] do
    resources :match_availabilities, :only => [:create, :destroy]
    member do
      post 'notify'
      get 'edit_lineup' => 'match_lineups#edit'
    end
  end
end

